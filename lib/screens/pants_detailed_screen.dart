import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PantsDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const PantsDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EFEF),

      body: SafeArea(
        child: Column(
          children: [

            /// IMAGE + BACK BUTTON
            Stack(
              children: [
                Image.asset(
                  product['image'],
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),

                Positioned(
                  top: 20,
                  left: 10,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                ),
              ],
            ),

            /// DETAILS
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30)),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      product['name'],
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "₹${product['price']}",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Premium quality pants, comfortable and stylish for everyday wear.",
                      style: TextStyle(color: Colors.grey),
                    ),

                    SizedBox(height: 20),

                    /// SIZE OPTIONS (optional)
                    Row(
                      children: [
                        _sizeBox("S"),
                        _sizeBox("M"),
                        _sizeBox("L"),
                        _sizeBox("XL"),
                      ],
                    ),

                    Spacer(),

                    /// ADD TO CART
                    GestureDetector(
                      onTap: () {
                        addToCart(context);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Add to Cart",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SIZE BOX
  Widget _sizeBox(String size) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(size),
    );
  }

  /// HIVE FUNCTION
  void addToCart(BuildContext context) {
    var box = Hive.box('cart');

    box.add({
      "name": product['name'],
      "price": product['price'],
      "image": product['image'],
      "quantity": 1,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Added to cart")),
    );
  }
}