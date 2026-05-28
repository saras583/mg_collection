import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mgcollection_app/views/user/screens/orderstatusScreen.dart';

class Orderbagscreen extends StatelessWidget {
  const Orderbagscreen({super.key});

  @override
  Widget build(BuildContext context) {

    final orderBox =
        Hive.box('orders');

    return Scaffold(

      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

      appBar: AppBar(

        centerTitle: true,

        title: const Text(
          "My Orders",
        ),
      ),

      body: ValueListenableBuilder(

        valueListenable:
            orderBox.listenable(),

        builder:
            (context, Box box, _) {

          /// EMPTY
          if (box.isEmpty) {

            return Center(

              child: Column(

                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),

                  const SizedBox(height: 20),

                  const Text(

                    "No Orders Yet",

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(

                    "Your orders will appear here",

                    style: TextStyle(
                      color:
                          Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(

            padding:
                const EdgeInsets.all(16),

            itemCount: box.length,

            itemBuilder:
                (context, index) {

              final item =
                  Map<String, dynamic>.from(
                box.getAt(index),
              );

              return GestureDetector(

                onTap: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) =>

                          OrderStatusScreen(
                            order: item,
                          ),
                    ),
                  );
                },

                child: Container(

                  margin:
                      const EdgeInsets.only(
                    bottom: 18,
                  ),

                  padding:
                      const EdgeInsets.all(
                    14,
                  ),

                  decoration: BoxDecoration(

                    color:
                        Theme.of(context)
                            .cardColor,

                    borderRadius:
                        BorderRadius.circular(
                      24,
                    ),

                    boxShadow: [

                      BoxShadow(

                        color: Colors.black
                            .withOpacity(
                          0.05,
                        ),

                        blurRadius: 12,

                        offset:
                            const Offset(
                          0,
                          4,
                        ),
                      ),
                    ],
                  ),

                  child: Row(

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      /// PRODUCT IMAGE
                      Container(

                        height: 100,
                        width: 100,

                        decoration:
                            BoxDecoration(

                          color: Colors
                              .grey
                              .shade100,

                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),

                        child: ClipRRect(

                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),

                          child: Image.network(

                            item['image'] ??
                                "",

                            fit: BoxFit.cover,

                            errorBuilder: (
                              context,
                              error,
                              stackTrace,
                            ) {

                              return Container(

                                color: Colors
                                    .grey
                                    .shade300,

                                child: const Center(

                                  child: Icon(
                                    Icons
                                        .image_not_supported,
                                    size: 35,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 15,
                      ),

                      /// DETAILS
                      Expanded(

                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            /// NAME
                            Text(

                              item['name'] ??
                                  "",

                              maxLines: 2,

                              overflow:
                                  TextOverflow
                                      .ellipsis,

                              style:
                                  const TextStyle(

                                fontSize: 17,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            /// CATEGORY
                            Text(

                              item['category'] ??
                                  "",

                              style:
                                  TextStyle(

                                color:
                                    Colors.grey
                                        .shade600,

                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            /// PRICE
                            Text(

                              "₹${item['price']}",

                              style:
                                  const TextStyle(

                                fontSize: 18,

                                fontWeight:
                                    FontWeight.bold,

                                color:
                                    Colors.green,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            /// SIZE + QUANTITY
                            Row(

                              children: [

                                Container(

                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal:
                                        10,
                                    vertical:
                                        5,
                                  ),

                                  decoration:
                                      BoxDecoration(

                                    color: Colors
                                        .grey
                                        .shade100,

                                    borderRadius:
                                        BorderRadius.circular(
                                      20,
                                    ),
                                  ),

                                  child: Text(

                                    "Size: ${item['size'] ?? 'M'}",
                                  ),
                                ),

                                const SizedBox(
                                  width: 10,
                                ),

                                Container(

                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal:
                                        10,
                                    vertical:
                                        5,
                                  ),

                                  decoration:
                                      BoxDecoration(

                                    color: Colors
                                        .grey
                                        .shade100,

                                    borderRadius:
                                        BorderRadius.circular(
                                      20,
                                    ),
                                  ),

                                  child: Text(

                                    "Qty: ${item['quantity']}",
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            /// PAYMENT
                            Row(

                              children: [

                                Icon(

                                  Icons
                                      .payments_outlined,

                                  size: 18,

                                  color:
                                      Colors.grey
                                          .shade600,
                                ),

                                const SizedBox(
                                  width: 6,
                                ),

                                Expanded(

                                  child: Text(

                                    item['payment'] ??
                                        "",

                                    style:
                                        TextStyle(

                                      color:
                                          Colors
                                              .grey
                                              .shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            /// STATUS
                            Row(

                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,

                              children: [

                                Container(

                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal:
                                        14,
                                    vertical:
                                        7,
                                  ),

                                  decoration:
                                      BoxDecoration(

                                    color:

                                        item['status'] ==
                                                "Completed"

                                            ? Colors.green
                                                .shade100

                                            : Colors.orange
                                                .shade100,

                                    borderRadius:
                                        BorderRadius.circular(
                                      30,
                                    ),
                                  ),

                                  child: Text(

                                    item['status'] ??
                                        "Pending",

                                    style:
                                        TextStyle(

                                      color:

                                          item['status'] ==
                                                  "Completed"

                                              ? Colors
                                                  .green

                                              : Colors
                                                  .orange,

                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ),

                                /// RATING
                                Row(

                                  children: [

                                    const Icon(
                                      Icons.star,
                                      color:
                                          Colors.amber,
                                      size: 18,
                                    ),

                                    const SizedBox(
                                      width: 4,
                                    ),

                                    Text(

                                      item['rating']
                                              ?.toString() ??
                                          "0",
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            /// TIME
                            Text(

                              item['time'] ??
                                  "",

                              style:
                                  TextStyle(

                                fontSize: 11,

                                color:
                                    Colors.grey
                                        .shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}