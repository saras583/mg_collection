import 'package:flutter/material.dart';
import 'package:mgcollection_app/admin/products/add_products.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/product_tile.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Products')),
      drawer: const AdminDrawer(),
      body: ListView(
        children: const [
          ProductTile(name: 'Classic Tailored Suit', price: ''),
          ProductTile(name: 'Oxford Dress Shoes', price: ''),
          ProductTile(name: 'Denim Jacket', price: ''),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProductScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
