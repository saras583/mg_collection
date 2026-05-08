import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mgcollection_app/screens/bottomnavigationbarScreen.dart';
import 'package:mgcollection_app/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool obscurePassword = true;

  /// LOGIN FUNCTION
  void loginUser() {

    String email =
        emailController.text
            .trim()
            .toLowerCase();

    String password =
        passwordController.text
            .trim();

    /// EMPTY CHECK
    if (email.isEmpty ||
        password.isEmpty) {

      showMsg(
        "Please fill all fields",
      );

      return;
    }

    var userBox =
        Hive.box('userBox');

    var authBox =
        Hive.box('authBox');

    List users =
        userBox.get(
          'users',
          defaultValue: [],
        );

    Map<String, dynamic>? user;

    try {

      user = users.firstWhere(

        (u) =>

            u['email']
                    .toString()
                    .toLowerCase() ==
                email &&

            u['password'] ==
                password,
      );

    } catch (e) {

      user = null;
    }

    /// LOGIN SUCCESS
    if (user != null) {

      authBox.put(
        'isLoggedIn',
        true,
      );

      authBox.put(
        'currentUser',
        email,
      );

      showMsg(
        "Login Successful",
      );

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>
              const Bottomnavigationbarscreen(),
        ),
      );

    } else {

      /// LOGIN FAILED
      showMsg(
        "Invalid Email or Password",
      );
    }
  }

  /// SNACKBAR
  void showMsg(String msg) {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(
        content: Text(msg),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(20),

          child: Column(

            children: [

              const SizedBox(height: 60),

              /// TITLE
              const Text(

                "Welcome Back",

                style: TextStyle(

                  fontSize: 28,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(

                "Login to continue shopping",

                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 40),

              /// EMAIL
              Align(

                alignment:
                    Alignment.centerLeft,

                child: const Text(
                  "Email Address",
                ),
              ),

              const SizedBox(height: 8),

              TextField(

                controller:
                    emailController,

                keyboardType:
                    TextInputType.emailAddress,

                decoration:
                    InputDecoration(

                  hintText:
                      "Enter your email",

                  filled: true,

                  fillColor:
                      Colors.white,

                  border:
                      OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(
                      30,
                    ),

                    borderSide:
                        BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// PASSWORD
              Align(

                alignment:
                    Alignment.centerLeft,

                child: const Text(
                  "Password",
                ),
              ),

              const SizedBox(height: 8),

              TextField(

                controller:
                    passwordController,

                obscureText:
                    obscurePassword,

                decoration:
                    InputDecoration(

                  hintText:
                      "Enter your password",

                  filled: true,

                  fillColor:
                      Colors.white,

                  suffixIcon:
                      IconButton(

                    icon: Icon(

                      obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),

                    onPressed: () {

                      setState(() {

                        obscurePassword =
                            !obscurePassword;
                      });
                    },
                  ),

                  border:
                      OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(
                      30,
                    ),

                    borderSide:
                        BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// LOGIN BUTTON
              GestureDetector(

                onTap: loginUser,

                child: Container(

                  width: double.infinity,

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 16,
                  ),

                  decoration: BoxDecoration(

                    color: Colors.blue,

                    borderRadius:
                        BorderRadius.circular(
                      30,
                    ),
                  ),

                  child: const Center(

                    child: Text(

                      "Login",

                      style: TextStyle(

                        color: Colors.white,

                        fontWeight:
                            FontWeight.bold,

                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// GOOGLE BUTTON
              Container(

                width: double.infinity,

                padding:
                    const EdgeInsets.symmetric(
                  vertical: 16,
                ),

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    30,
                  ),
                ),

                child: const Center(

                  child: Text(
                    "Sign in with Google",
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// REGISTER LINK
              GestureDetector(

                onTap: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) =>
                          const RegisterScreen(),
                    ),
                  );
                },

                child: const Text(

                  "Don't Have An Account? Sign Up",

                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}