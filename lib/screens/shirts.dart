import 'package:flutter/material.dart';
import 'package:mgcollection_app/screens/shirt_details_screen.dart';

class ShirtsScreen extends StatefulWidget {
  const ShirtsScreen({super.key});

  @override
  State<ShirtsScreen> createState() =>
      _ShirtsScreenState();
}

class _ShirtsScreenState
    extends State<ShirtsScreen> {

  String selectedFilter = 'Default';

  List<Map<String, dynamic>> shirts = [

    {
      "name": "Black Linen Shirt",
      "price": 899,
      "image":
          "assets/images/black_shirt.jpg",
      "rating": 4.5,
    },

    {
      "name": "Casual Shirt",
      "price": 799,
      "image":
          "assets/images/laventer.jpg",
      "rating": 3.5,
    },

    {
      "name": "Blue Denim Shirt",
      "price": 999,
      "image":
          "assets/images/checkshirt.jpg",
      "rating": 4.2,
    },

    {
      "name": "Checked Cotton Shirt",
      "price": 849,
      "image":
          "assets/images/black_shirt.jpg",
      "rating": 4.0,
    },

    {
      "name": "Lavender Shirt",
      "price": 950,
      "image":
          "assets/images/laventer.jpg",
      "rating": 4.7,
    },

    {
      "name": "Striped Office Shirt",
      "price": 899,
      "image":
          "assets/images/checkshirt.jpg",
      "rating": 4.3,
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(

        child: Column(

          children: [

            /// TOP BAR
            Padding(

              padding:
                  const EdgeInsets.all(16),

              child: Row(

                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                children: [

                  const Text(

                    "Shirts",

                    style: TextStyle(

                      fontSize: 28,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  Row(

                    children: [

                      /// FILTER
                      PopupMenuButton<String>(

                        icon: const Icon(
                          Icons.tune,
                        ),

                        onSelected: (value) {

                          setState(() {

                            selectedFilter =
                                value;

                            if (value ==
                                'Low to High') {

                              shirts.sort(

                                (a, b) =>

                                    a['price']
                                        .compareTo(
                                      b['price'],
                                    ),
                              );

                            } else if (value ==
                                'High to Low') {

                              shirts.sort(

                                (a, b) =>

                                    b['price']
                                        .compareTo(
                                      a['price'],
                                    ),
                              );

                            } else if (value ==
                                'A-Z') {

                              shirts.sort(

                                (a, b) =>

                                    a['name']
                                        .compareTo(
                                      b['name'],
                                    ),
                              );

                            } else if (value ==
                                'Rating') {

                              shirts.sort(

                                (a, b) =>

                                    b['rating']
                                        .compareTo(
                                      a['rating'],
                                    ),
                              );
                            }
                          });
                        },

                        itemBuilder:
                            (context) => [

                          const PopupMenuItem(
                            value:
                                'Low to High',

                            child: Text(
                              'Price: Low to High',
                            ),
                          ),

                          const PopupMenuItem(
                            value:
                                'High to Low',

                            child: Text(
                              'Price: High to Low',
                            ),
                          ),

                          const PopupMenuItem(
                            value: 'A-Z',

                            child: Text(
                              'Name: A-Z',
                            ),
                          ),

                          const PopupMenuItem(
                            value: 'Rating',

                            child: Text(
                              'Top Rated',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      const Icon(
                        Icons.search,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// PRODUCTS GRID
            Expanded(

              child: GridView.builder(

                padding:
                    const EdgeInsets.all(12),

                itemCount: shirts.length,

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount: 2,

                  crossAxisSpacing: 14,

                  mainAxisSpacing: 14,

                  childAspectRatio: 0.68,
                ),

                itemBuilder:
                    (context, index) {

                  final shirtsList =
                      shirts[index];

                  return GestureDetector(

                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>

                              ShirtDetailsScreen(
                                product:
                                    shirtsList,
                              ),
                        ),
                      );
                    },

                    child: Container(

                      padding:
                          const EdgeInsets.all(
                        12,
                      ),

                      decoration: BoxDecoration(

                        color: Theme.of(context).scaffoldBackgroundColor,

                        borderRadius:
                            BorderRadius.circular(
                          22,
                        ),

                        boxShadow: [

                          BoxShadow(

                            color: Colors.black
                                .withOpacity(
                              0.05,
                            ),

                            blurRadius: 10,

                            offset:
                                const Offset(
                              0,
                              4,
                            ),
                          ),
                        ],
                      ),

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          /// IMAGE
                          Expanded(

                            child: Container(

                              width:
                                  double.infinity,

                              decoration:
                                  BoxDecoration(

                                color: Colors
                                    .grey
                                    .shade100,

                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),
                              ),

                              child: ClipRRect(

                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),

                                child: Image.asset(

                                  shirtsList[
                                      'image'],

                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          /// PRODUCT NAME
                          Text(

                            shirtsList['name'],

                            maxLines: 1,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                const TextStyle(

                              fontSize: 15,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          /// RATING
                          Row(

                            children: [

                              const Icon(

                                Icons.star,

                                color:
                                    Colors.orange,

                                size: 16,
                              ),

                              const SizedBox(
                                width: 5,
                              ),

                              Text(

                                shirtsList[
                                        'rating']
                                    .toString(),

                                style:
                                    const TextStyle(
                                  color:
                                      Colors.grey,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          /// PRICE + BUTTON
                          Row(

                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,

                            children: [

                              Text(

                                "₹${shirtsList['price']}",

                                style:
                                    const TextStyle(

                                  fontSize: 17,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              Container(

                                padding:
                                    const EdgeInsets.all(
                                  8,
                                ),

                                decoration:
                                    BoxDecoration(

                                  color:
                                      Colors.black,

                                  borderRadius:
                                      BorderRadius.circular(
                                    12,
                                  ),
                                ),

                                child: const Icon(

                                  Icons
                                      .shopping_bag_outlined,

                                  color:
                                      Colors.white,

                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}