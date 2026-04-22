import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mgcollection_app/screens/checkoutpage.dart';

class BlackShirtDetails extends StatelessWidget {
  const BlackShirtDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFEF),

      body: SafeArea(
        child: Column(
          children: [

            /// IMAGE + BACK BUTTON
            Stack(
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/black_shirt.jpg",
                    fit: BoxFit.contain,
                  ),
                ),

                Positioned(
                  top: 10,
                  left: 10,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                ),
              ],
            ),

            /// DETAILS SECTION
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "BEST SELLER",
                      style: TextStyle(color: Colors.blue),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Black Shirt",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "₹499",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "This black shirt is made from premium cotton fabric. Comfortable, stylish and perfect for daily wear.",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    /// SIZE OPTIONS
                    Row(
                      children: [
                        _sizeBox("S"),
                        _sizeBox("M"),
                        _sizeBox("L"),
                        _sizeBox("XL"),
                      ],
                    ),

                    const Spacer(),

                    /// BOTTOM SECTION
                    Row(
                      children: [

                        /// PRICE
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Price", style: TextStyle(color: Colors.grey)),
                            Text(
                              "₹499",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        const Spacer(),

                        /// ADD TO CART
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              addToCart(context, {
                                "name": "Black Shirt",
                                "price": 499,
                                "image": "assets/images/black_shirt.jpg",
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Center(
                                child: Text(
                                  "Add to Cart",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// BUY NOW
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Proceeding to Buy"),
                                ),
                              );

                              //  Navigate to checkout page later
                               //Navigator.push(context, MaterialPageRoute(builder: (_) => C));
                            },
                            
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Center(
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

  /// SIZE BOX
  Widget _sizeBox(String size) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(size),
    );
  }

  /// ADD TO CART FUNCTION
  void addToCart(BuildContext context, Map<String, dynamic> product) {
    var box = Hive.box('cart');
    box.add(product);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to cart')),
    );
  }
}