import 'package:flutter/material.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/product_tile.dart';
import 'add_product.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Products')),
      drawer: const AdminDrawer(),
      body: ListView(
        children: const [
          ProductTile(name: 'Classic Tailored Suit', price: '$250.00'),
          ProductTile(name: 'Oxford Dress Shoes', price: '$120.00'),
          ProductTile(name: 'Denim Jacket', price: '$85.00'),
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
