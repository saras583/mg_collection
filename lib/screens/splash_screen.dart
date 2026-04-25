import 'package:flutter/material.dart';
import 'package:mgcollection_app/screens/login_screen.dart';
import 'package:mgcollection_app/screens/theme_controller.dart';

class SplashScreen extends StatefulWidget {

  final ThemeController controller;

  const SplashScreen({super.key, required this.controller});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checklogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag, size: 80),
            SizedBox(height: 20),
            Text(
              "MGCollection",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void checklogin() async {
    Future.delayed(Duration(seconds: 2),
    () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen(controller: ThemeController())),
      );
  });}
    }
  

