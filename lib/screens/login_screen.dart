import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mgcollection_app/screens/bottomnavigationbarScreen.dart';
import 'package:mgcollection_app/screens/register_screen.dart';
import 'package:mgcollection_app/screens/theme_controller.dart';

class LoginScreen extends StatefulWidget {
  final ThemeController controller;

  const LoginScreen({super.key,required this.controller});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  void loginUser() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    var userBox = Hive.box('userBox');
    var authBox = Hive.box('authBox');

    List users = userBox.get('users', defaultValue: []);

    final user = users.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => null,
    );

    if (user != null) {
      authBox.put('isLoggedIn', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Bottomnavigationbarscreen(controller: widget.controller),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              /// BACK BUTTON
              Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.arrow_back),
                ),
              ),

              SizedBox(height: 30),

              /// TITLE
              Text(
                "Hello Again!",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 8),

              Text(
                "Welcome Back You've Been Missed!",
                style: TextStyle(color: Colors.grey),
              ),

              SizedBox(height: 30),

              /// EMAIL
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Email Address"),
              ),

              SizedBox(height: 8),

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

              SizedBox(height: 20),

              /// PASSWORD
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Password"),
              ),

              SizedBox(height: 8),

              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  filled: true,
                  fillColor: Colors.white,
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 10),

              /// FORGOT PASSWORD
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recovery Password",
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              SizedBox(height: 25),

              /// SIGN IN BUTTON
              GestureDetector(
                onTap: loginUser,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              /// GOOGLE BUTTON
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color:  Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text("Sign in with Google"),
                ),
              ),

              Spacer(),

              /// REGISTER
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegisterScreen(),
                    ),
                  );
                },
                child: Text(
                  "Don’t Have An Account? Sign Up For Free",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
