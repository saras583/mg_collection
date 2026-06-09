import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/admin/admin_user_screen.dart';
import 'package:mgcollection_app/views/admin/screens/addcategoies.dart';
import 'package:mgcollection_app/views/admin/screens/admin_bannerscreen.dart';
import 'package:mgcollection_app/views/admin/screens/admindashbored.dart';
import 'package:mgcollection_app/views/admin/screens/orderscreen.dart';
import 'package:mgcollection_app/views/admin/screens/productscreen.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int currentIndex = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = const [
  DashboardScreen(),      
  AdminProductScreen(),   
  AdminOrderScreen(),
   AdminCategoryScreen(),     
  AdminBannerScreen(),    
  Adminuserscreen(),
       
];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF5DA9E9),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library_outlined), 
            label: 'Banners',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}