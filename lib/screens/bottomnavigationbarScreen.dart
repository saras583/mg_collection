import 'package:flutter/material.dart';
import 'package:mgcollection_app/screens/explore_screen.dart';
import 'package:mgcollection_app/screens/home_screen.dart';
import 'package:mgcollection_app/screens/cart.dart';
import 'package:mgcollection_app/screens/profile_screen.dart';

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
    Cart(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color.fromARGB(255, 189, 185, 195),
      body: Screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(backgroundColor: const Color.fromARGB(255, 206, 205, 208),
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [BottomNavigationBarItem(icon: Icon(Icons.home),backgroundColor:Color(0xFFE6E6FA) ,label: 'home'),
        BottomNavigationBarItem(icon: Icon(Icons.explore),label: 'explore'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label: 'cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person),label: 'home') ],
        
      ),
    );
  }
}
