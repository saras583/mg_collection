import 'package:flutter/material.dart';
import 'package:mgcollection_app/screens/skincare_details.dart';

class Skincarescreen extends StatefulWidget {
  const Skincarescreen({super.key});

  @override
  State<Skincarescreen> createState() =>
      _SkincarescreenState();
}

class _SkincarescreenState
    extends State<Skincarescreen> {

  String selectedFilter = 'Default';

  List<Map<String, dynamic>> skincare = [

    {
      "name": "Face Cleanser",
      "price": 499,
      "image":
          "assets/images/cetapfilne.jpg",
      "rating": 4.5,
    },

    {
      "name": "Moisturizing Cream",
      "price": 699,
      "image":
          "assets/images/vitaminc serm.jpg",
      "rating": 4.8,
    },

    {
      "name": "Sunscreen SPF 50",
      "price": 599,
      "image":
          "assets/images/sunscreen.jpg",
      "rating": 4.3,
    },

    {
      "name": "Face Wash Gel",
      "price": 399,
      "image":
          "assets/images/simplefacewash.jpg",
      "rating": 4.1,
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

                    "Skincare",

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

                              skincare.sort(

                                (a, b) =>

                                    a['price']
                                        .compareTo(
                                      b['price'],
                                    ),
                              );

                            } else if (value ==
                                'High to Low') {

                              skincare.sort(

                                (a, b) =>

                                    b['price']
                                        .compareTo(
                                      a['price'],
                                    ),
                              );

                            } else if (value ==
                                'A-Z') {

                              skincare.sort(

                                (a, b) =>

                                    a['name']
                                        .compareTo(
                                      b['name'],
                                    ),
                              );

                            } else if (value ==
                                'Rating') {

                              skincare.sort(

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

                itemCount:
                    skincare.length,

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount: 2,

                  crossAxisSpacing: 14,

                  mainAxisSpacing: 14,

                  childAspectRatio: 0.68,
                ),

                itemBuilder:
                    (context, index) {

                  final skincares =
                      skincare[index];

                  return GestureDetector(

                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>

                              SkincareDetailsScreen(
                                product:
                                    skincares,
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

                                  skincares[
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

                            skincares['name'],

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

                                skincares[
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

                                "₹${skincares['price']}",

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