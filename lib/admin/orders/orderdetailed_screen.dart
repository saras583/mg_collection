import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Order #001 Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Customer: John Doe'),
            Text('Item: Classic Tailored Suit'),
            Text('Status: Delivered'),
            Text('Total: $250.00'),
          ],
        ),
      ),
    );
  }
}
