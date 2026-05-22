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

      bottomNavigationBar: BottomNavigationBar(backgroundColor: const Color.fromARGB(255, 13, 13, 13),
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [BottomNavigationBarItem(icon: Icon(Icons.home),backgroundColor:Color(0xFFE6E6FA) ,label: 'home'),
        BottomNavigationBarItem(icon: Icon(Icons.explore),label: 'bestsellers'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label: 'cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person),label: 'home') ],
        
      ),
    );
  }
}
