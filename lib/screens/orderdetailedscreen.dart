import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Center(
              child: Image.asset(
                order['image'],
                height: 150,
              ),
            ),

            SizedBox(height: 20),

            Text(
              order['name'],
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text("Price: ₹${order['price']}"),
            Text("Payment: ${order['payment']}"),
            Text("Quantity: ${order['quantity'] ?? 1}"),

            SizedBox(height: 20),

            Divider(),

            Text(
              "Shipping Address",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text("Kinfra, Kerala"),

            SizedBox(height: 20),

            Divider(),

            Text(
              "Order Status",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text("Processing"),

            SizedBox(height: 20),

            Divider(),

            Text(
              "Order Time",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(order['time']),
          ],
        ),
      ),
    );
  }
}