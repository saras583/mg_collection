import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mgcollection_app/screens/cart.dart';
import 'package:mgcollection_app/screens/checkoutpage.dart';

class ShoesDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ShoesDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ShoesDetailsScreen> createState() =>
      _ShoesDetailsScreenState();
}

class _ShoesDetailsScreenState
    extends State<ShoesDetailsScreen> {

  int quantity = 1;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

      body: SafeArea(

        child: Column(

          children: [

            /// IMAGE SECTION
            Stack(

              children: [

                Image.asset(

                  widget.product['image'],

                  height: 300,

                  width: double.infinity,

                  fit: BoxFit.contain,
                ),

                /// BACK BUTTON
                Positioned(

                  top: 20,

                  left: 10,

                  child: GestureDetector(

                    onTap: () {
                      Navigator.pop(context);
                    },

                    child: const CircleAvatar(

                      backgroundColor:
                          Colors.black,

                      child: Icon(
                        Icons.arrow_back,
                      ),
                    ),
                  ),
                ),

                /// FAVORITE BUTTON
                Positioned(

                  top: 20,

                  right: 10,

                  child: GestureDetector(

                    onTap: () {

                      var favBox =
                          Hive.box('favorites');

                      favBox.add(
                        widget.product,
                      );

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(

                        const SnackBar(
                          content: Text(
                            "Added to Favorites",
                          ),
                        ),
                      );
                    },

                    child: const CircleAvatar(

                      backgroundColor:
                          Colors.white,

                      child: Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// DETAILS SECTION
            Expanded(

              child: Container(

                padding:
                    const EdgeInsets.all(20),

                decoration: BoxDecoration(

                  color:
                      Theme.of(context)
                          .cardColor,

                  borderRadius:
                      const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),

                child: SingleChildScrollView(

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      /// PRODUCT NAME
                      Text(

                        widget.product['name'],

                        style: const TextStyle(

                          fontSize: 22,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// PRICE
                      Text(

                        "₹${widget.product['price']}",

                        style: const TextStyle(

                          fontSize: 20,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// DESCRIPTION
                      const Text(

                        "High-quality running shoes for comfort and performance.",

                        style: TextStyle(
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// SIZE OPTIONS
                      Row(

                        children: [

                          _sizeBox("38"),

                          _sizeBox("39"),

                          _sizeBox("40"),

                          _sizeBox("41"),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// RATING
                      Row(

                        children: const [

                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),

                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),

                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),

                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),

                          Icon(
                            Icons.star_half,
                            color: Colors.amber,
                          ),

                          SizedBox(width: 8),

                          Text("4.5"),
                        ],
                      ),

                      const SizedBox(height: 25),

                      /// QUANTITY TITLE
                      const Text(

                        "Quantity",

                        style: TextStyle(

                          fontWeight:
                              FontWeight.bold,

                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// QUANTITY SELECTOR
                      Row(

                        children: [

                          /// MINUS BUTTON
                          GestureDetector(

                            onTap: () {

                              if (quantity > 1) {

                                setState(() {

                                  quantity--;
                                });
                              }
                            },

                            child: Container(

                              padding:
                                  const EdgeInsets.all(
                                8,
                              ),

                              decoration: BoxDecoration(

                                color:
                                    Colors.grey.shade300,

                                borderRadius:
                                    BorderRadius.circular(
                                  10,
                                ),
                              ),

                              child:
                                  const Icon(Icons.remove),
                            ),
                          ),

                          const SizedBox(width: 20),

                          /// QUANTITY TEXT
                          Text(

                            quantity.toString(),

                            style: const TextStyle(

                              fontSize: 18,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(width: 20),

                          /// PLUS BUTTON
                          GestureDetector(

                            onTap: () {

                              if (quantity < 5) {

                                setState(() {

                                  quantity++;
                                });

                              } else {

                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(

                                  const SnackBar(

                                    content: Text(
                                      "Maximum 5 allowed",
                                    ),
                                  ),
                                );
                              }
                            },

                            child: Container(

                              padding:
                                  const EdgeInsets.all(
                                8,
                              ),

                              decoration: BoxDecoration(

                                color: Colors.blue,

                                borderRadius:
                                    BorderRadius.circular(
                                  10,
                                ),
                              ),

                              child: const Icon(

                                Icons.add,

                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      /// REVIEWS TITLE
                      const Text(

                        "Reviews",

                        style: TextStyle(

                          fontWeight:
                              FontWeight.bold,

                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// REVIEW 1
                      const ListTile(

                        contentPadding:
                            EdgeInsets.zero,

                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                        ),

                        title: Text("Akhil"),

                        subtitle: Text(
                          "Very good product!",
                        ),
                      ),

                      /// REVIEW 2
                      const ListTile(

                        contentPadding:
                            EdgeInsets.zero,

                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                        ),

                        title: Text("Sarah"),

                        subtitle: Text(
                          "Excellent quality shoes.",
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            /// FIXED BUTTONS
            Container(

              padding:
                  const EdgeInsets.all(20),

              decoration: BoxDecoration(

                color:
                    Theme.of(context).cardColor,

                boxShadow: const [

                  BoxShadow(

                    blurRadius: 10,

                    color: Colors.black12,
                  ),
                ],
              ),

              child: Row(

                children: [

                  /// ADD TO CART
                  Expanded(

                    child: GestureDetector(

                      onTap: () {
                        addToCart(context);
                      },

                      child: Container(

                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 14,
                        ),

                        decoration: BoxDecoration(

                          color:
                              Colors.grey.shade300,

                          borderRadius:
                              BorderRadius.circular(
                            30,
                          ),
                        ),

                        child: const Center(

                          child: Text(

                            "Add to Cart",

                            style: TextStyle(
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// BUY NOW
                  Expanded(

                    child: GestureDetector(

                      onTap: () {
                        buyNow(context);
                      },

                      child: Container(

                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 14,
                        ),

                        decoration: BoxDecoration(

                          color: Colors.blue,

                          borderRadius:
                              BorderRadius.circular(
                            30,
                          ),
                        ),

                        child: const Center(

                          child: Text(

                            "Buy Now",

                            style: TextStyle(

                              color: Colors.white,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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

      margin:
          const EdgeInsets.only(right: 10),

      padding:
          const EdgeInsets.all(10),

      decoration: BoxDecoration(

        color: Colors.grey.shade200,

        borderRadius:
            BorderRadius.circular(10),
      ),

      child: Text(size),
    );
  }

  /// ADD TO CART
  void addToCart(BuildContext context) {

    var box = Hive.box('cart');

    List cartItems =
        box.values.toList();

    int existingIndex =
        cartItems.indexWhere(

      (item) =>
          item['name'] ==
          widget.product['name'],
    );

    /// PRODUCT EXISTS
    if (existingIndex != -1) {

      var existingItem =
          cartItems[existingIndex];

      int currentQuantity =
          existingItem['quantity'];

      int newQuantity =
          currentQuantity + quantity;

      if (newQuantity > 5) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content: Text(
              "Maximum 5 allowed",
            ),
          ),
        );

        return;
      }

      existingItem['quantity'] =
          newQuantity;

      box.putAt(
        existingIndex,
        existingItem,
      );

    } else {

      box.add({

        "name":
            widget.product['name'],

        "price":
            widget.product['price'],

        "image":
            widget.product['image'],

        "quantity":
            quantity,
      });
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        behavior:
            SnackBarBehavior.floating,

        margin:
            const EdgeInsets.all(16),

        content:
            const Text("Added to cart"),

        action: SnackBarAction(

          label: "Go to Cart",

          onPressed: () {

            Navigator.push(

              context,

              MaterialPageRoute(
                builder: (_) => const Cart(),
              ),
            );
          },
        ),
      ),
    );
  }

  /// BUY NOW
  void buyNow(BuildContext context) {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => Checkoutpage(

          product: {

            "name":
                widget.product['name'],

            "price":
                widget.product['price'],

            "image":
                widget.product['image'],

            "quantity":
                quantity,
          },
        ),
      ),
    );
  }
}