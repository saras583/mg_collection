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

        title: const Text(
          "My Orders",
        ),
      ),

      body: ValueListenableBuilder(

        valueListenable:
            orderBox.listenable(),

        builder:
            (context, Box box, _) {

          if (box.isEmpty) {

            return const Center(

              child: Text(

                "No Orders Yet",

                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.builder(

            padding:
                const EdgeInsets.all(12),

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
                    bottom: 15,
                  ),

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

                  child: Row(

                    children: [

                      /// PRODUCT IMAGE
                      Container(

                        height: 90,
                        width: 90,

                        padding:
                            const EdgeInsets.all(
                          8,
                        ),

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

                            item['image'],

                            fit: BoxFit.cover,
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

                            /// PRODUCT NAME
                            Text(

                              item['name'] ??
                                  "",

                              maxLines: 2,

                              overflow:
                                  TextOverflow
                                      .ellipsis,

                              style:
                                  const TextStyle(

                                fontSize: 16,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            /// PRICE
                            Text(

                              "₹${item['price']}",

                              style:
                                  const TextStyle(

                                fontSize: 16,

                                fontWeight:
                                    FontWeight.bold,

                                color:
                                    Colors.green,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            /// PAYMENT
                            Row(

                              children: [

                                const Icon(

                                  Icons
                                      .payments_outlined,

                                  size: 16,

                                  color:
                                      Colors.grey,
                                ),

                                const SizedBox(
                                  width: 5,
                                ),

                                Text(

                                  item['payment'] ??
                                      "",

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.grey,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            /// STATUS
                            Container(

                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal:
                                    12,
                                vertical: 6,
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
                                  20,
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

                            const SizedBox(
                              height: 8,
                            ),

                            /// TIME
                            Text(

                              item['time'] ??
                                  "",

                              style:
                                  const TextStyle(

                                fontSize: 11,

                                color:
                                    Colors.grey,
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