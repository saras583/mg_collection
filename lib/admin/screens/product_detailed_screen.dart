import 'dart:io';

import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {

  final Map product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {

    int stock =
        int.tryParse(
          product["stock"].toString(),
        ) ?? 0;

    Color stockColor = Colors.green;

    String stockText = "In Stock";

    if (stock <= 5) {

      stockColor = Colors.orange;
      stockText = "Low Stock";
    }

    if (stock == 0) {

      stockColor = Colors.red;
      stockText = "Out Of Stock";
    }

    return Scaffold(

      appBar: AppBar(
        title: Text(
          product["name"] ?? "Product",
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Container(

              height: 300,
              width: double.infinity,

              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: ClipRRect(

                borderRadius:
                    BorderRadius.circular(20),

                child:

                    product["image"] != null &&
                            product["image"] != ""

                        ? Image.file(
                            File(product["image"]),
                            fit: BoxFit.cover,
                          )

                        : const Icon(
                            Icons.image,
                            size: 100,
                          ),
              ),
            ),

            const SizedBox(height: 20),

            Text(

              product["name"] ?? "",

              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(

              "₹${product["price"] ?? "0"}",

              style: const TextStyle(
                fontSize: 24,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Container(

              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),

              decoration: BoxDecoration(

                color: Colors.blue.shade100,

                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: Text(

                product["category"] ??
                    "No Category",

                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(

              "Stock: $stock",

              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Container(

              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),

              decoration: BoxDecoration(

                color:
                    stockColor.withOpacity(0.15),

                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: Text(

                stockText,

                style: TextStyle(
                  color: stockColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(

              "Description",

              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(

              product["description"] ??
                  "No Description",

              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}