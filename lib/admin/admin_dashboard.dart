import 'package:flutter/material.dart';
import 'package:mgcollection_app/admin/manage_products.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Dashboard"),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisSpacing: 1,
          mainAxisSpacing: 2,
          crossAxisCount: 2,
          children: <Widget>[
            _adminCard(Icons.shopping_bag, 'Mange products',(){
              Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ManageProductsScreen(),
      ),
    );
            }), _adminCard(Icons.receipt_long, "Manage Orders",(){
              
            }),
            _adminCard(Icons.people, "Manage Users",(){}),
            _adminCard(Icons.inventory, "Stock",(){}),
            _adminCard(Icons.local_offer, "Coupons",(){}),
            _adminCard(Icons.image, "Banners",(){}),],
        ),
      ),
    );
  }
}

_adminCard(IconData icon, String title, VoidCallback onTap) {
  return GestureDetector(onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color:  Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
