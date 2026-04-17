import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BlackShirtDetails extends StatelessWidget {
  const BlackShirtDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EFEF),

      body: SafeArea(
        child: Column(
          children: [
            ///  BACK BUTTON // IMAGE
            Stack(
              children: [
                Container(
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
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                ),
              ],
            ),

            ///  DETAILS
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("BEST SELLER", style: TextStyle(color: Colors.blue)),

                    SizedBox(height: 5),

                    Text(
                      "Black Shirt",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      "₹499",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "This black shirt is made from premium cotton fabric. Comfortable, stylish and perfect for daily wear.",
                      style: TextStyle(color: Colors.grey),
                    ),

                    SizedBox(height: 20),

                    /// SIZE
                    Row(
                      children: [
                        _sizeBox("S"),
                        _sizeBox("M"),
                        _sizeBox("L"),
                        _sizeBox("XL"),
                      ],
                    ),

                    Spacer(),Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [

    /// PRICE
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Price", style: TextStyle(color: Colors.grey)),
        Text("₹499", style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
///  ADD TO CART
                    GestureDetector(
                      onTap: () {
                        addToCart(context, {
    "name": "Black Shirt",
    "price": 499,
    "image": "assets/images/black_shirt.jpg",
  });
                      },
                      
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          
               
                          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text("Add to Cart", style: TextStyle(color: Colors.white)),
          ),
                        ),
                      ),
                    ),
                    
                  ],
                ),
          ]
          ),
            ),
        )],
        ),
      ),
    );
  }

  ///  SIZE BOX
  Widget _sizeBox(String size) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(size),
    );
  }

  void addToCart(BuildContext context, Map<String, dynamic> products) {
    var box = Hive.box('cart');
    box.add(products);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('added to cart')));
  }
}
