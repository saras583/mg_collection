import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class WatchesDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const WatchesDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EFEF),

      body: Column(
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
                top: 40,
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
          GestureDetector(onTap: (){
            
          },
            child: Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
            
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
            
                    SizedBox(height: 10),
            
                    Text(
                      "₹${product['price']}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
            
                    SizedBox(height: 10),
            
                    Text(
                      "Premium shirt, comfortable and stylish.",
                      style: TextStyle(color: Colors.grey),
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
          ),
        ],
      ),
    );
  }

  void addToCart(BuildContext context) {
    var box = Hive.box('cart');

    box.add({
      "name": product['name'],
      "price": product['price'],
      "image": product['image'],
      "quantity": 1,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Added to cart")));
  }
}
