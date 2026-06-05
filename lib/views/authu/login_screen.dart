import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mgcollection_app/views/admin/screens/admin_home.dart';
import 'package:mgcollection_app/views/authu/otp_screen.dart';
import 'package:mgcollection_app/views/authu/register_screen.dart';
import 'package:mgcollection_app/views/user/screens/bottomnavigationbarScreen.dart';
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
  bool _navigating = false;

  @override
  void initState() {
    super.initState();

    _checkCurrentSession();

    _authSubscription = supabase.auth.onAuthStateChange.listen((data) async {
      final session = data.session;

      log("AUTH EVENT: ${data.event}");
log("AUTH USER ID: ${session?.user.id}");
      if (session != null) {
        await _handleLoggedInUser(session.user);
      }
    });
  }

  Future<void> sendOtp() async {
    try {
      await supabase.auth.signInWithOtp(email: emailController.text.trim());

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpScreen(email: emailController.text.trim()),
        ),
      );
    } on AuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _checkCurrentSession() async {
    final session = supabase.auth.currentSession;

    if (session != null) {
      await _handleLoggedInUser(session.user);
    }
  }

  Future<void> _handleLoggedInUser(User user) async {
  if (_navigating) return;
  _navigating = true;

  try {
    // Use maybeSingle() instead of single() — returns null if no row exists
    Map<String, dynamic>? userData = await supabase
        .from('users')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    // First-time Google sign-in: create the user row
    if (userData == null) {
      await supabase.from('users').insert({
        'id': user.id,
        'email': user.email,
        'role': 'user',
        'blocked': false,
        // add any other fields your table requires
      });

      userData = await supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .single();
    }

    if (userData['blocked'] == true) {
      await supabase.auth.signOut();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your account has been blocked by the admin')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
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
    print('_handleLoggedInUser error: $e');
  }
}

  Future<void> login() async {
    setState(() {
      loading = true;
    });

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      

      final result = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> continueWithGoogle() async {
    try {
      GoogleSignIn signIn = GoogleSignIn.instance;
      await signIn.initialize(
        serverClientId: dotenv.env['WEB_CLIENT_1'],
        clientId: Platform.isAndroid
            ? dotenv.env['ANDROID_CLIENT_1']
            : dotenv.env['IOS_CLIENT_1'],
      );
      GoogleSignInAccount account = await signIn.authenticate();
      String idToken = account.authentication.idToken ?? '';
      final authorization =
          await account.authorizationClient.authorizationForScopes([
            'email',
            'profile',
          ]) ??
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
        print(result.user?.id);
        print(result.user?.email);
        await _handleLoggedInUser(result.user!);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF5EFEF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_ios_new),
                      ),
                    ),
                  ),

                  const SizedBox(height: 70),

                  const Text(
                    "Hello Again!",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Welcome Back You've Been Missed!",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  const SizedBox(height: 50),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "example@gmail.com",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 20,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        hintText: "Enter Password",
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5DA9E9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                      onPressed: loading ? null : login,
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Sign In",
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
                    onTap: continueWithGoogle,
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('assets/images/search.png'),
                            height: 25,
                          ),
                          SizedBox(width: 15),
                          Text(
                            "Sign in with Google",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
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
                      const Text(
                        "Don’t Have An Account?",
                        style: TextStyle(color: Colors.grey),
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
                        child: const Text(
                          " Sign Up For free",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
}