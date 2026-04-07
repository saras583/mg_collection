import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mgcollection_app/screens/bottomnavigationbarScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Loginuser();
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
              controller: usernameController,
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
                Loginuser();
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

  void Loginuser() {
    var userBox = Hive.box('users');

    String email = usernameController.text;
    String password = passwordController.text;

    var user = userBox.get(email);

    if (user != null && user["password"] == password) {
      //save login
      var authBox = Hive.box('auth');
      authBox.put("isLogged", true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Bottomnavigationbarscreen()),
      );
    } else {
      //  message the user and pass is not
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid email or password")));
    }
  }
}
