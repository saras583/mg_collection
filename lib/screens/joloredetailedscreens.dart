import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'checkoutpage.dart';

class JewelleryDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const JewelleryDetailsScreen({super.key, required this.product});

  @override
  State<JewelleryDetailsScreen> createState() => _JewelleryDetailsScreenState();
}

class _JewelleryDetailsScreenState extends State<JewelleryDetailsScreen> {

  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Column(
          children: [

            /// 🔝 IMAGE + BACK
            Stack(
              children: [
                Image.asset(
                  widget.product['image'],
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.contain,
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
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30)),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// NAME
                    Text(
                      widget.product['name'],
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    /// PRICE
                    Text(
                      "₹${widget.product['price']}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),

                    SizedBox(height: 10),

                    /// DESCRIPTION
                    Text(
                      "Elegant jewellery made with premium materials. Perfect for all occasions.",
                      style: TextStyle(color: Colors.grey),
                    ),

                    SizedBox(height: 20),

                    ///  RATING (UI only)
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 18),
                        Icon(Icons.star, color: Colors.orange, size: 18),
                        Icon(Icons.star, color: Colors.orange, size: 18),
                        Icon(Icons.star, color: Colors.orange, size: 18),
                        Icon(Icons.star_half, color: Colors.orange, size: 18),
                        SizedBox(width: 5),
                        Text("4.5"),
                      ],
                    ),

                    SizedBox(height: 20),

                    ///  QUANTITY SELECTOR
                    Row(
                      children: [
                        Text("Quantity:",
                            style: TextStyle(fontWeight: FontWeight.bold)),

                        SizedBox(width: 15),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade200,
                          ),
                          child: Row(
                            children: [

                              /// MINUS
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  if (quantity > 1) {
                                    setState(() {
                                      quantity--;
                                    });
                                  }
                                },
                              ),

                              Text("$quantity"),

                              /// PLUS
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Spacer(),

                    ///  BUTTONS
                    Row(
                      children: [

                        /// ADD TO CART
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              addToCart(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Checkoutpage(
                                    product: widget.product,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
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

  ///  ADD TO CART
  void addToCart(BuildContext context) {
    var box = Hive.box('cart');

    box.add({
      "name": widget.product['name'],
      "price": widget.product['price'],
      "image": widget.product['image'],
      "quantity": quantity,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Added $quantity item(s) to cart")),
    );
  }
}