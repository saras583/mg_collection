import 'package:flutter/material.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: 'Product Name')),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'Price')),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: () {}, child: const Text('Save Product'))
          ],
        ),
      ),
    );
  }
}
