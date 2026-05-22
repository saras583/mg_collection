import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/user/screens/watches_details_screen.dart';

class WatchesScreen extends StatefulWidget {
  const WatchesScreen({super.key});

  @override
  State<WatchesScreen> createState() =>
      _WatchesScreenState();
}

class _WatchesScreenState
    extends State<WatchesScreen> {

  String selectedFilter = 'Default';

  List<Map<String, dynamic>> watches = [

    {
      "name": "Rolex Submariner",
      "price": 1299.0,
      "image":
          "assets/images/watch.jpg",
      "rating": 4.5,
    },

    {
      "name": "Apple Watch Ultra",
      "price": 2499.0,
      "image":
          "assets/images/Casio A168WGG-1B 🖤.jpg",
      "rating": 4.8,
    },

    {
      "name": "Casio G-Shock",
      "price": 1999.0,
      "image":
          "assets/images/download (2).jpg",
      "rating": 4.3,
    },

    {
      "name": "Fossil Gen 6",
      "price": 2999.0,
      "image":
          "assets/images/Seiko 5 Automatic Watch for Men _ Classic Steel Timepiece.jpg",
      "rating": 4.6,
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

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

                    "Watches",

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

                              watches.sort(

                                (a, b) =>

                                    a['price']
                                        .compareTo(
                                      b['price'],
                                    ),
                              );

                            } else if (value ==
                                'High to Low') {

                              watches.sort(

                                (a, b) =>

                                    b['price']
                                        .compareTo(
                                      a['price'],
                                    ),
                              );

                            } else if (value ==
                                'A-Z') {

                              watches.sort(

                                (a, b) =>

                                    a['name']
                                        .compareTo(
                                      b['name'],
                                    ),
                              );

                            } else if (value ==
                                'Rating') {

                              watches.sort(

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
                    watches.length,

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount: 2,

                  crossAxisSpacing: 14,

                  mainAxisSpacing: 14,

                  childAspectRatio: 0.68,
                ),

                itemBuilder:
                    (context, index) {

                  final watch =
                      watches[index];

                  return GestureDetector(

                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>

                              WatchesDetailsScreen(
                                product:
                                    watch,
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

                        color:
                            Theme.of(context)
                                .scaffoldBackgroundColor,

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

                                  watch['image'],

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

                            watch['name'],

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

                                watch['rating']
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

                                "₹${watch['price']}",

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