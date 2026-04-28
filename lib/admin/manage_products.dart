import 'package:flutter/material.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Products"),
      ),
      body: Center(
        child: Text(
          "Product Management Here",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}