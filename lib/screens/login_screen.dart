import 'package:flutter/material.dart';

import 'package:mgcollection_app/screens/bottomnavigationbarScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    if (email == "saras@gmail.com" && password == "1234") {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setBool("isLoggedIn", true);
      await prefs.setString("email", email);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Bottomnavigationbarscreen()),
      );
    } else {
      // WRONG LOGIN
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid email or password")));
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 100),
            const SizedBox(height: 50),

            const Text(
              "Hello Again!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            const Text(
              "Welcome Back You’ve Been Missed!",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Email Address"),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Enter your email",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Password"),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Enter password",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                loginUser();
              },

              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(child: Text("Sign in with Google")),
            ),
            const Spacer(),

            const Text(
              "Don’t Have An Account? Sign Up For Free",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  void checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

    if (isLoggedIn) {
      Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Bottomnavigationbarscreen()),
      );
    }
  }
}
