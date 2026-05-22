import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/admin/adminuserscreen.dart';
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

  final List<Widget> screens = [
     DashboardScreen(),
     AdminProductScreen(),
     AdminOrderScreen(),
     Adminuserscreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Products",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Orders",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Users",
          ),
        ],
        
      ),
    );
  }
}

