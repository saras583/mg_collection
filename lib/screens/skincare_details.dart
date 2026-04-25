import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mgcollection_app/screens/checkoutpage.dart';

class SkincareDetailsScreen extends StatelessWidget {
  
  final Map<String, dynamic> product;

  const SkincareDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

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

                    /// NAME
                    Text(
                      product['name'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    /// PRICE
                    Text(
                      "₹${product['price']}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    /// DESCRIPTION
                    Text(
                      "High quality skincare product for healthy and glowing skin.",
                      style: TextStyle(color: Colors.grey),
                    ),

                    Spacer(),

                    Divider(),
                    SizedBox(height: 10),

                    //BUTTONS
                    Row(
                      children: [

                        /// ADD TO CART
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              addToCart(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text("Add to Cart"),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 10),

                        /// BUY NOW
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              buyNow(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  "Buy Now",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  /// ADD TO CART
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

  /// BUY NOW
  void buyNow(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Checkoutpage(product: product),
      ),
    );
  }
}