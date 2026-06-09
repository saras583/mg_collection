import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mgcollection_app/views/admin/screens/admin_home.dart';
import 'package:mgcollection_app/views/authu/otp_screen.dart';
import 'package:mgcollection_app/views/user/screens/bottomnavigationbarScreen.dart';
import 'package:mgcollection_app/views/authu/register_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final supabase = Supabase.instance.client;

  StreamSubscription<AuthState>? _authSubscription;

  bool obscurePassword = true;
  bool loading = false;
  bool googleLoading = false;
  bool otpLoading = false;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();

    _checkCurrentSession();

    _authSubscription = supabase.auth.onAuthStateChange.listen((data) async {
      final session = data.session;

      log('AUTH EVENT: ${data.event}');
      log('AUTH USER ID: ${session?.user.id}');

      if (session != null) {
        await _handleLoggedInUser(session.user);
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkCurrentSession() async {
    final session = supabase.auth.currentSession;

    if (session != null) {
      await _handleLoggedInUser(session.user);
    }
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack('Please enter email and password');
      return;
    }

    setState(() => loading = true);

    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      _showSnack(e.message);
    } catch (e) {
      if (!mounted) return;
      _showSnack('Login failed. Please try again.');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> sendOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _showSnack('Please enter your email first');
      return;
    }

    setState(() => otpLoading = true);

    try {
      await supabase.auth.signInWithOtp(
        email: email,
        shouldCreateUser: true,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpScreen(email: email),
        ),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      _showSnack(e.message);
    } catch (e) {
      if (!mounted) return;
      _showSnack('Failed to send OTP. Please try again.');
    } finally {
      if (mounted) setState(() => otpLoading = false);
    }
  }

  Future<void> continueWithGoogle() async {
    if (googleLoading) return;

    setState(() => googleLoading = true);

    try {
      final signIn = GoogleSignIn.instance;

      await signIn.initialize(
        serverClientId: dotenv.env['WEB_CLIENT_1'],
        clientId: Platform.isAndroid
            ? dotenv.env['ANDROID_CLIENT_1']
            : dotenv.env['IOS_CLIENT_1'],
      );

      final account = await signIn.authenticate();
      final idToken = account.authentication.idToken ?? '';

      final authorization =
          await account.authorizationClient.authorizationForScopes([
        'email',
        'profile',
      ]);

      final result = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: authorization?.accessToken,
      );

      if (result.user != null && result.session != null) {
        await _handleLoggedInUser(result.user!);
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      _showSnack(e.message);
    } catch (e) {
      if (!mounted) return;
      _showSnack('Google sign in failed. Please try again.');
    } finally {
      if (mounted) setState(() => googleLoading = false);
    }
  }

  Future<void> _handleLoggedInUser(User user) async {
    if (_navigating) return;
    _navigating = true;

    try {
      final metadata = user.userMetadata ?? {};

      final fallbackName =
          metadata['name'] ??
          metadata['full_name'] ??
          metadata['display_name'] ??
          user.email?.split('@').first ??
          'User';

      Map<String, dynamic>? userData = await supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (userData == null) {
        await supabase.from('users').upsert({
          'id': user.id,
          'email': user.email,
          'name': fallbackName,
          'role': 'user',
          'blocked': false,
        });

        userData = await supabase
            .from('users')
            .select()
            .eq('id', user.id)
            .maybeSingle();
      }

      if (userData == null) {
        throw Exception('Unable to load user profile');
      }

      if (userData['blocked'] == true) {
        await supabase.auth.signOut();

        _navigating = false;

        if (!mounted) return;

        _showSnack('Your account has been blocked by the admin');
        return;
      }

      if (!mounted) return;

      if (userData['role'] == 'admin') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AdminHome()),
          (_) => false,
        );
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Bottomnavigationbarscreen()),
        (_) => false,
      );
    } catch (e) {
      _navigating = false;

      if (!mounted) return;

      _showSnack('Login failed. Please try again.');
    }
  }

  void _showSnack(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = theme.cardColor;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey;
    final backBtnColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: backBtnColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 70),

                  Text(
                    'Hello Again!',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Welcome Back You've Been Missed!",
                    style: TextStyle(
                      fontSize: 16,
                      color: subtitleColor,
                    ),
                  ),

                  const SizedBox(height: 50),

                  _inputField(
                    controller: emailController,
                    hint: 'example@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    cardColor: cardColor,
                    colorScheme: colorScheme,
                    subtitleColor: subtitleColor,
                  ),

                  const SizedBox(height: 30),

                  _passwordField(cardColor, colorScheme, subtitleColor),

                  const SizedBox(height: 25),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: otpLoading ? null : sendOtp,
                      child: otpLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF5DA9E9),
                              ),
                            )
                          : const Text(
                              'Login with OTP',
                              style: TextStyle(
                                color: Color(0xFF5DA9E9),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5DA9E9),
                        disabledBackgroundColor:
                            const Color(0xFF5DA9E9).withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                      onPressed: loading ? null : login,
                      child: loading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  GestureDetector(
                    onTap: googleLoading ? null : continueWithGoogle,
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(
                            image: AssetImage('assets/images/search.png'),
                            height: 25,
                          ),
                          const SizedBox(width: 15),
                          googleLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF5DA9E9),
                                  ),
                                )
                              : Text(
                                  'Sign in with Google',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't Have An Account?",
                        style: TextStyle(color: subtitleColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          ' Sign Up For free',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required Color cardColor,
    required ColorScheme colorScheme,
    required Color subtitleColor,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: colorScheme.onSurface),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          hintText: hint,
          hintStyle: TextStyle(color: subtitleColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),
        ),
      ),
    );
  }

  Widget _passwordField(
    Color cardColor,
    ColorScheme colorScheme,
    Color subtitleColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: passwordController,
        obscureText: obscurePassword,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) {
          if (!loading) login();
        },
        style: TextStyle(color: colorScheme.onSurface),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          hintText: 'Enter Password',
          hintStyle: TextStyle(color: subtitleColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: subtitleColor,
            ),
            onPressed: () {
              setState(() => obscurePassword = !obscurePassword);
            },
          ),
        ),
      ),
    );
  }
}