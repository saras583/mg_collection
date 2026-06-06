import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/user/screens/bestsellers_screen.dart';
import 'package:mgcollection_app/views/user/screens/home_screen.dart';
import 'package:mgcollection_app/views/user/screens/orderbagscreen.dart';
import 'package:mgcollection_app/views/user/screens/profile_screen.dart';

class Bottomnavigationbarscreen extends StatefulWidget {
  

  const Bottomnavigationbarscreen({super.key});

  @override
  State<Bottomnavigationbarscreen> createState() =>
      _BottomnavigationbarscreenState();
}

class _BottomnavigationbarscreenState extends State<Bottomnavigationbarscreen> {
  int currentIndex = 0;

  final List Screens = [
    HomeScreen(),
    ExploreScreen(),
    Orderbagscreen(),
    ProfileScreen(),
  ];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
  backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor 
      ?? Theme.of(context).scaffoldBackgroundColor, 
  selectedItemColor: const Color(0xFF5DA9E9),       
  unselectedItemColor: Colors.grey,
  type: BottomNavigationBarType.fixed,              
  currentIndex: currentIndex,
  onTap: (index) {
    setState(() {
      currentIndex = index;
    });
  },
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Bestsellers'),
    BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'), // ✅ fixed label
  ],
),
    );
  }
}
