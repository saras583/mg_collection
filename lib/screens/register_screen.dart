import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mgcollection_app/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final nameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;

  bool obscureConfirmPassword = true;

  /// REGISTER FUNCTION
  void registerUser() {

    String name =
        nameController.text.trim();

    String email =
        emailController.text
            .trim()
            .toLowerCase();

    String password =
        passwordController.text
            .trim();

    String confirmPassword =
        confirmPasswordController
            .text
            .trim();

    /// EMPTY VALIDATION
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {

      showMsg(
        "Please fill all fields",
      );

      return;
    }

    /// PASSWORD MATCH
    if (password !=
        confirmPassword) {

      showMsg(
        "Passwords do not match",
      );

      return;
    }

    /// PASSWORD LENGTH
    if (password.length < 6) {

      showMsg(
        "Password must be at least 6 characters",
      );

      return;
    }

    var userBox =
        Hive.box('userBox');

    List users =
        userBox.get(
          'users',
          defaultValue: [],
        );

    /// EMAIL ALREADY EXISTS
    bool exists = users.any(

      (u) =>

          u['email']
                  .toString()
                  .toLowerCase() ==
              email,
    );

    if (exists) {

      showMsg(
        "Email already registered",
      );

      return;
    }

    /// SAVE USER
    users.add({

      "name": name,

      "email": email,

      "password": password,
    });

    userBox.put(
      'users',
      users,
    );

    showMsg(
      "Registration Successful",
    );

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (_) =>
            const LoginScreen(),
      ),
    );
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

              const SizedBox(height: 40),

              /// TITLE
              const Text(

                "Create Account",

                style: TextStyle(

                  fontSize: 28,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(

                "Register to start shopping",

                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 40),

              /// NAME
              Align(

                alignment:
                    Alignment.centerLeft,

                child: const Text(
                  "Full Name",
                ),
              ),

              const SizedBox(height: 8),

              TextField(

                controller:
                    nameController,

                decoration:
                    InputDecoration(

                  hintText:
                      "Enter your name",

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
                      "Enter password",

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

              const SizedBox(height: 20),

              /// CONFIRM PASSWORD
              Align(

                alignment:
                    Alignment.centerLeft,

                child: const Text(
                  "Confirm Password",
                ),
              ),

              const SizedBox(height: 8),

              TextField(

                controller:
                    confirmPasswordController,

                obscureText:
                    obscureConfirmPassword,

                decoration:
                    InputDecoration(

                  hintText:
                      "Confirm password",

                  filled: true,

                  fillColor:
                      Colors.white,

                  suffixIcon:
                      IconButton(

                    icon: Icon(

                      obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),

                    onPressed: () {

                      setState(() {

                        obscureConfirmPassword =
                            !obscureConfirmPassword;
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

              /// REGISTER BUTTON
              GestureDetector(

                onTap: registerUser,

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

                      "Register",

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

              const SizedBox(height: 30),

              /// LOGIN LINK
              GestureDetector(

                onTap: () {

                  Navigator.pop(context);
                },

                child: const Text(

                  "Already have an account? Login",

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