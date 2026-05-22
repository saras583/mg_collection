import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/user/screens/shirt_details_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() =>
      _ExploreScreenState();
}

class _ExploreScreenState
    extends State<ExploreScreen> {

  String selectedFilter = 'Default';

  List<Map<String, dynamic>> products = [

    {
      "name": "Watches",
      "category": "Accessories",
      "price": 367.76,
      "image":
          "assets/images/watch.jpg",
      "rating": 4.5,
    },

    {
      "name": "Pant",
      "category": "Fashion",
      "price": 299.99,
      "image":
          "assets/images/grey trouser.jpg",
      "rating": 4.2,
    },

    {
      "name": "Nike Jordan",
      "category": "Shoes",
      "price": 399.99,
      "image":
          "assets/images/air1.jpg",
      "rating": 4.8,
    },

    {
      "name": "Shirt",
      "category": "Fashion",
      "price": 249.99,
      "image":
          "assets/images/black_shirt.jpg",
      "rating": 4.4,
    },

    {
      "name": "Black Linen Shirt",
      "category": "Shirts",
      "price": 899,
      "image":
          "assets/images/black_shirt.jpg",
      "rating": 4.7,
    },

    {
      "name": "Casual Shirt",
      "category": "Shirts",
      "price": 799,
      "image":
          "assets/images/laventer.jpg",
      "rating": 4.3,
    },

    {
      "name": "Blue Denim Shirt",
      "category": "Shirts",
      "price": 999,
      "image":
          "assets/images/checkshirt.jpg",
      "rating": 4.6,
    },

    {
      "name": "Checked Cotton Shirt",
      "category": "Shirts",
      "price": 849,
      "image":
          "assets/images/black_shirt.jpg",
      "rating": 4.5,
    },

    {
      "name": "Lavender Shirt",
      "category": "Shirts",
      "price": 950,
      "image":
          "assets/images/laventer.jpg",
      "rating": 4.1,
    },

    {
      "name": "Striped Office Shirt",
      "category": "Shirts",
      "price": 899,
      "image":
          "assets/images/checkshirt.jpg",
      "rating": 4.2,
    },

    {
      "name": "Slim Fit Jeans",
      "category": "Pants",
      "price": 1299,
      "image":
          "assets/images/grey trouser.jpg",
      "rating": 4.7,
    },

    {
      "name": "Formal Trousers",
      "category": "Pants",
      "price": 999,
      "image":
          "assets/images/next.jpg",
      "rating": 4.3,
    },

    {
      "name": "Cargo Pants",
      "category": "Pants",
      "price": 1499,
      "image":
          "assets/images/next.jpg",
      "rating": 4.6,
    },

    {
      "name": "Spider Ring",
      "category": "Jewellery",
      "price": 2999,
      "image":
          "assets/images/spiderring.jpg",
      "rating": 4.9,
    },

    {
      "name": "Mountain Ring",
      "category": "Jewellery",
      "price": 4999,
      "image":
          "assets/images/mountainrings.jpg",
      "rating": 4.8,
    },

    {
      "name": "Ring Gravur",
      "category": "Jewellery",
      "price": 1999,
      "image":
          "assets/images/Ring  Gravur.jpg",
      "rating": 4.2,
    },

    {
      "name": "Face Cleanser",
      "category": "Skincare",
      "price": 499,
      "image":
          "assets/images/cetapfilne.jpg",
      "rating": 4.4,
    },

    {
      "name": "Moisturizing Cream",
      "category": "Skincare",
      "price": 699,
      "image":
          "assets/images/vitaminc serm.jpg",
      "rating": 4.5,
    },

    {
      "name": "Sunscreen SPF 50",
      "category": "Skincare",
      "price": 599,
      "image":
          "assets/images/sunscreen.jpg",
      "rating": 4.6,
    },

    {
      "name": "Face Wash Gel",
      "category": "Skincare",
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

                    "Best Sellers",

                    style: TextStyle(

                      fontSize: 28,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  Row(

                    children: [

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

                              products.sort(

                                (a, b) =>

                                    a['price']
                                        .compareTo(
                                      b['price'],
                                    ),
                              );

                            } else if (value ==
                                'High to Low') {

                              products.sort(

                                (a, b) =>

                                    b['price']
                                        .compareTo(
                                      a['price'],
                                    ),
                              );

                            } else if (value ==
                                'A-Z') {

                              products.sort(

                                (a, b) =>

                                    a['name']
                                        .compareTo(
                                      b['name'],
                                    ),
                              );

                            } else if (value ==
                                'Rating') {

                              products.sort(

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
                    products.length,

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount: 2,

                  crossAxisSpacing: 14,

                  mainAxisSpacing: 14,

                  childAspectRatio: 0.68,
                ),

                itemBuilder:
                    (context, index) {

                  final product =
                      products[index];

                  return GestureDetector(

                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>

                              ShirtDetailsScreen(
                                product:
                                    product,
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
                                .cardColor,

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

                                  product["image"],

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

                            product["name"],

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
                            height: 5,
                          ),

                          /// CATEGORY
                          Text(

                            product["category"],

                            style: TextStyle(

                              fontSize: 12,

                              color:
                                  Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
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

                                product["rating"]
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

                                "₹${product["price"]}",

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