import 'package:flutter/material.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: 'Product Name', hintText: 'Classic Tailored Suit')),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'Price', hintText: '$250.00')),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: () {}, child: const Text('Update Product'))
          ],
        ),
      ),
    );
  }
}
