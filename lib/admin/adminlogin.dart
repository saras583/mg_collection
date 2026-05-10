import 'package:flutter/material.dart';
import 'package:mgcollection_app/admin/admin_dasbord.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('ADMIN LOGIN', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              const TextField(decoration: InputDecoration(labelText: 'Username', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              const TextField(decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()), obscureText: true),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Text('Login'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
