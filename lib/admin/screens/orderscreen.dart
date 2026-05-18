import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() =>
      _AdminOrderScreenState();
}

class _AdminOrderScreenState
    extends State<AdminOrderScreen> {

  final orderBox = Hive.box('orders');

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Orders"),
      ),

      body: orderBox.isEmpty

          ? const Center(
              child: Text(
                "No Orders Found",
              ),
            )

          : ListView.builder(

              padding: const EdgeInsets.all(12),

              itemCount: orderBox.length,

              itemBuilder: (context, index) {

                final order =
                    orderBox.getAt(index);

                final customer =
                    order["customer"] ??
                        "Unknown User";

                final phone =
                    order["phone"] ??
                        "No Phone";

                final product =
                    order["product"] ??
                        "No Product";

                final price =
                    order["price"]
                        ?.toString() ??
                        "0";

                final status =
                    order["status"] ??
                        "Pending";

                return Card(

                  margin:
                      const EdgeInsets.only(
                    bottom: 15,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                  ),

                  child: Padding(

                    padding:
                        const EdgeInsets.all(
                      15,
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                          children: [

                            Expanded(

                              child: Text(

                                customer,

                                style:
                                    const TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),

                            Container(

                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),

                              decoration:
                                  BoxDecoration(

                                color:
                                    status ==
                                            "Completed"

                                        ? Colors
                                            .green
                                            .shade100

                                        : Colors
                                            .orange
                                            .shade100,

                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),
                              ),

                              child: Text(

                                status,

                                style:
                                    TextStyle(

                                  color:
                                      status ==
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
                          ],
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        Row(
                          children: [

                            const Icon(
                              Icons.phone,
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Expanded(
                              child: Text(
                                phone,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Row(
                          children: [

                            const Icon(
                              Icons.shopping_bag,
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Expanded(
                              child: Text(
                                product,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Row(
                          children: [

                            const Icon(
                              Icons.currency_rupee,
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Text(price),
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Row(
                          children: [

                            Expanded(

                              child:
                                  ElevatedButton(

                                onPressed: () {

                                  setState(() {

                                    if (status ==
                                        "Pending") {

                                      orderBox.putAt(
                                        index,
                                        {

                                          ...order,

                                          "status":
                                              "Completed",
                                        },
                                      );

                                    } else {

                                      orderBox.putAt(
                                        index,
                                        {

                                          ...order,

                                          "status":
                                              "Pending",
                                        },
                                      );
                                    }
                                  });
                                },

                                style:
                                    ElevatedButton.styleFrom(

                                  backgroundColor:
                                      status ==
                                              "Pending"

                                          ? Colors
                                              .green

                                          : Colors
                                              .orange,
                                ),

                                child: Text(

                                  status ==
                                          "Pending"

                                      ? "Mark Completed"

                                      : "Mark Pending",

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                  ),
                                ),
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
    );
  }
}