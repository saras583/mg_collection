import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/authu/login_screen.dart';
import 'package:mgcollection_app/views/user/screens/bottomnavigationbarScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final supabase = Supabase.instance.client;

  bool obscurePassword = true;
  bool loading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnack('Please fill all fields');
      return;
    }

    if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(email)) {
      _showSnack('Please enter a valid email address');
      return;
    }

    if (password.length < 6) {
      _showSnack('Password must be at least 6 characters');
      return;
    }

    setState(() => loading = true);

    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'full_name': name,
        },
      );

      if (!mounted) return;

      final user = response.user;
      final session = response.session;

      if (user == null) {
        _showSnack('Registration failed. Please try again.');
        return;
      }

      if (session != null) {
        await supabase.from('users').upsert({
          'id': user.id,
          'email': email,
          'name': name,
          'role': 'user',
          'blocked': false,
        });

        if (!mounted) return;

        _showSnack('Registration successful', success: true);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const Bottomnavigationbarscreen(),
          ),
          (route) => false,
        );
      } else {
        _showSnack('Account created. Please check your email to verify login.',
            success: true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      _showSnack(e.message);
    } catch (e) {
      if (!mounted) return;
      _showSnack('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => loading = false);
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
    final cardColor = theme.cardColor;
    final isDark = theme.brightness == Brightness.dark;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey;

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
                          color: cardColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Register to continue shopping',
                    style: TextStyle(fontSize: 16, color: subtitleColor),
                  ),
                  const SizedBox(height: 40),
                  _fieldLabel('Name', colorScheme),
                  const SizedBox(height: 15),
                  _inputField(
                    controller: nameController,
                    hint: 'Enter Name',
                    icon: Icons.person_outline,
                    cardColor: cardColor,
                    colorScheme: colorScheme,
                    subtitleColor: subtitleColor,
                  ),
                  const SizedBox(height: 25),
                  _fieldLabel('Email Address', colorScheme),
                  const SizedBox(height: 15),
                  _inputField(
                    controller: emailController,
                    hint: 'example@gmail.com',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    cardColor: cardColor,
                    colorScheme: colorScheme,
                    subtitleColor: subtitleColor,
                  ),
                  const SizedBox(height: 25),
                  _fieldLabel('Password', colorScheme),
                  const SizedBox(height: 15),
                  _passwordField(cardColor, colorScheme, subtitleColor),
                  const SizedBox(height: 40),
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
                      onPressed: loading ? null : register,
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
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: subtitleColor),
                      ),
                      GestureDetector(
                        onTap: loading
                            ? null
                            : () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                ),
                        child: Text(
                          ' Login',
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

  Widget _fieldLabel(String label, ColorScheme colorScheme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
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
          prefixIcon: Icon(icon, color: subtitleColor),
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
          if (!loading) register();
        },
        style: TextStyle(color: colorScheme.onSurface),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          hintText: 'Enter Password',
          hintStyle: TextStyle(color: subtitleColor),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.lock_outline, color: subtitleColor),
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