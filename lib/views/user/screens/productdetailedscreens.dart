import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/user/screens/checkoutpage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mgcollection_app/models/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState
    extends State<ProductDetailsScreen> {

  bool isFavorite = false;

  int quantity = 1;

  String selectedSize = 'M';

  double userRating = 5;

  final reviewController =
      TextEditingController();

  final List<String> sizes = [
    'S',
    'M',
    'L',
    'XL',
  ];

  List<Map<String, dynamic>> reviews = [];

  Future<void> submitReview() async {

  if (reviewController.text.trim().isEmpty) {
    return;
  }

  try {

    await Supabase.instance.client
        .from('productreviews')
        .insert({

      'product_id': widget.product.id,
      'user_name': 'Customer',
      'rating': userRating.toInt(),
      'review': reviewController.text.trim(),
    });

    setState(() {

      reviews.add({

        'name': 'Customer',
        'rating': userRating.toInt(),
        'review': reviewController.text.trim(),
      });
    });

    reviewController.clear();

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(
        content: Text(
          "Review submitted successfully",
        ),
      ),
    );

  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(
        content: Text(
          e.toString(),
        ),
      ),
    );

    print("Review Error: $e");
  }
}

    
    

  @override
  void dispose() {

    reviewController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final product = widget.product;

    return Scaffold(

      backgroundColor: Colors.white,

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),

        child: Row(
          children: [

            /// ADD TO CART
            Expanded(
              child: OutlinedButton(
                style:
                    OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),

                onPressed: () {

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        "${product.name} added to cart",
                      ),
                    ),
                  );
                },

                child: const Text(
                  "Add To Cart",
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// BUY NOW
            Expanded(
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),

                onPressed: () {

  Navigator.push(

    context,

    MaterialPageRoute(

      builder: (_) => Checkoutpage(

        product: {

          "name": product.name,

          "price": product.price,

          "image": product.image,

          "quantity": quantity,

          "size": selectedSize,

          "rating": product.rating,

          "description":
              product.description,

          "category":
              product.category,
        },
      ),
    ),
  );
},

                child: const Text(
                  "Buy Now",
                ),
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              /// IMAGE SECTION
              Stack(
                children: [

                  /// PRODUCT IMAGE
                  SizedBox(
                    height: 400,
                    width: double.infinity,

                    child: Image.network(
  product.image ,
  fit: BoxFit.cover,
  errorBuilder: (
    context,
    error,
    stackTrace,
  ) {
    return const Icon(
      Icons.broken_image,
      size: 80,
    );
  },
),
                  ),

                  /// BACK BUTTON
                  Positioned(
                    top: 16,
                    left: 16,

                    child: CircleAvatar(
                      backgroundColor:
                          Colors.white,

                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  /// FAVORITE BUTTON
                  Positioned(
                    top: 16,
                    right: 16,

                    child: CircleAvatar(
                      backgroundColor:
                          Colors.white,

                      child: IconButton(
                        onPressed: () {

                          setState(() {
                            isFavorite =
                                !isFavorite;
                          });
                        },

                        icon: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,

                          color: isFavorite
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    /// PRODUCT NAME
                    Text(
                      product.name,

                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// CATEGORY
                    Text(
                      product.category,

                      style: TextStyle(
                        color:
                            Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// RATING
                    Row(
                      children: [

                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),

                        const SizedBox(width: 5),

                        Text(
                          product.rating
                              .toString(),

                          style:
                              const TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Text(
                          "(${reviews.length} Reviews)",

                          style: TextStyle(
                            color: Colors
                                .grey.shade600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// PRICE
                    Text(
                      "₹${product.price}",

                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight:
                            FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// SIZE TITLE
                    const Text(
                      "Select Size",

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// SIZE SELECTION
                    Wrap(
                      spacing: 10,

                      children:
                          sizes.map((size) {

                        final isSelected =
                            selectedSize ==
                                size;

                        return ChoiceChip(
                          label: Text(size),

                          selected:
                              isSelected,

                          selectedColor:
                              Colors.black,

                          labelStyle:
                              TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.black,
                          ),

                          onSelected: (_) {

                            setState(() {
                              selectedSize =
                                  size;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 30),

                    /// QUANTITY TITLE
                    const Text(
                      "Quantity",

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// QUANTITY SELECTOR
                    Row(
                      children: [

                        Container(
                          decoration:
                              BoxDecoration(
                            border: Border.all(
                              color:
                                  Colors.grey,
                            ),

                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),
                          ),

                          child: Row(
                            children: [

                              IconButton(
                                onPressed: () {

                                  if (quantity >
                                      1) {

                                    setState(() {
                                      quantity--;
                                    });
                                  }
                                },

                                icon: const Icon(
                                  Icons.remove,
                                ),
                              ),

                              Text(
                                quantity
                                    .toString(),

                                style:
                                    const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              IconButton(
                                onPressed: () {

                                  if (quantity <
                                      5) {

                                    setState(() {
                                      quantity++;
                                    });
                                  } else {

                                    ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Maximum 5 items allowed",
                                        ),
                                      ),
                                    );
                                  }
                                },

                                icon: const Icon(
                                  Icons.add,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// DESCRIPTION TITLE
                    const Text(
                      "Description",

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// DESCRIPTION
                    Text(
                      product.description,

                      style: TextStyle(
                        fontSize: 16,
                        color:
                            Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// WRITE REVIEW TITLE
                    const Text(
                      "Write Review",

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// RATING SLIDER
                    Slider(
                      value: userRating,
                      min: 1,
                      max: 5,
                      divisions: 4,

                      label:
                          userRating.toString(),

                      onChanged: (value) {

                        setState(() {
                          userRating = value;
                        });
                      },
                    ),

                    /// REVIEW FIELD
                    TextField(
                      controller:
                          reviewController,
                      maxLines: 4,

                      decoration:
                          InputDecoration(
                        hintText:
                            "Write your review",

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            15,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// SUBMIT REVIEW BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(
                        onPressed:
                            submitReview,

                        child: const Text(
                          "Submit Review",
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// REVIEWS TITLE
                    const Text(
                      "Customer Reviews",

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// REVIEWS LIST
                    ListView.builder(
                      shrinkWrap: true,

                      physics:
                          const NeverScrollableScrollPhysics(),

                      itemCount:
                          reviews.length,

                      itemBuilder:
                          (context, index) {

                        final review =
                            reviews[index];

                        return Container(
                          margin:
                              const EdgeInsets.only(
                            bottom: 15,
                          ),

                          padding:
                              const EdgeInsets.all(
                            16,
                          ),

                          decoration:
                              BoxDecoration(
                            color: Colors
                                .grey.shade100,

                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),
                          ),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Row(
                                children: [

                                  CircleAvatar(
                                    child: Text(
                                      review["name"]
                                          [0],
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 10,
                                  ),

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [

                                      Text(
                                        review[
                                            "name"],

                                        style:
                                            const TextStyle(
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),

                                      Row(
                                        children:
                                            List.generate(
                                          review[
                                              "rating"],

                                          (index) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors
                                                .amber,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(
                                  height: 10),

                              Text(
                                review["review"],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}