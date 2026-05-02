import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mgcollection_app/screens/cart.dart';
import 'package:mgcollection_app/screens/checkoutpage.dart';

class PantsDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const PantsDetailsScreen({super.key, required this.product});

  @override
  State<PantsDetailsScreen> createState() => _PantsDetailsScreenState();
}

class _PantsDetailsScreenState extends State<PantsDetailsScreen> {
  final quantity = 1;

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
                  widget.product['image'],
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
                Positioned(
                  top: 20,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      var favBox = Hive.box('favorites');
                      favBox.add(widget.product);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Added to Favorites")),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.favorite_border, color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),

            /// DETAILS SECTION
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// PRODUCT NAME
                    Text(
                      widget.product['name'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    /// PRICE
                    Text(
                      "₹${widget.product['price']}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    /// DESCRIPTION
                    Text(
                      "Premium quality pants, comfortable and stylish for everyday wear.",
                      style: TextStyle(color: Colors.grey),
                    ),

                    SizedBox(height: 20),

                    /// SIZE OPTIONS
                    Row(
                      children: [
                        _sizeBox("S"),
                        _sizeBox("M"),
                        _sizeBox("L"),
                        _sizeBox("XL"),
                      ],
                    ),Row(
  children: [
    Icon(Icons.star, color: Colors.amber),
    Icon(Icons.star, color: Colors.amber),
    Icon(Icons.star, color: Colors.amber),
    Icon(Icons.star, color: Colors.amber),
    Icon(Icons.star_half, color: Colors.amber),
    SizedBox(width: 8),
    Text("4.5"),
  ],
),SizedBox(height: 20),

Text(
  "Quantity",
  style: TextStyle(
    fontWeight: FontWeight.bold,
  ),
),

Text(
  "Reviews",
  style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ),
),

SizedBox(height: 10),

ListTile(
  contentPadding: EdgeInsets.zero,
  leading: CircleAvatar(child: Icon(Icons.person)),
  title: Text("Akhil"),
  subtitle: Text("Very good product!"),
),

ListTile(
  contentPadding: EdgeInsets.zero,
  leading: CircleAvatar(child: Icon(Icons.person)),
  title: Text("Sarah"),
  subtitle: Text("Skin feels fresh after use."),
),

                    Spacer(),

                    Divider(),
                    SizedBox(height: 10),

                    
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
                                child: Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
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
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
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
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(size),
    );
  }

  /// ADD TO CART FUNCTION
  void addToCart(BuildContext context) {
    var box = Hive.box('cart');

    box.add({
      "name": widget.product['name'],
      "price": widget.product['price'],
      "image": widget.product['image'],
      "quantity": quantity,
    });

    ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(16),
    content: Text("Added to cart"),
    action: SnackBarAction(
      label: "Go to Cart",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Cart(),
          ),
        );
      },
    ),
  ),
);
  }

  /// BUY NOW FUNCTION
  void buyNow(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Checkoutpage(product: widget.product),
      ),
    );
  }
}