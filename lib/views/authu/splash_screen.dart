import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/authu/login_screen.dart';
import 'package:mgcollection_app/views/user/screens/bottomnavigationbarScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final supbase = Supabase.instance.client;

  checklogin() async {
    await Future.delayed(Duration(seconds: 2));

    final Session = supbase.auth.currentSession;

    if (Session ==null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Bottomnavigationbarscreen()),
      );
    }
  }

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
}
