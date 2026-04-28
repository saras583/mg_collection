import 'package:flutter/material.dart';
import 'admin_dashboard.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void loginAdmin() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == "callmesaras@gmail.com" && password == "saras123") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminDashboard(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid Admin Credentials"),
        ),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Icon(Icons.admin_panel_settings, size: 80),

              SizedBox(height: 20),
              
              Text(
                "Admin Login",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 30),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Admin Email",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 30),

              ElevatedButton(
                onPressed: loginAdmin,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text("Login as Admin"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}