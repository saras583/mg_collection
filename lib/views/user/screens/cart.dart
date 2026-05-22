import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mgcollection_app/views/user/screens/watches_details_screen.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    var box = Hive.box('cart');

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),

      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),

          builder: (context, Box box, _) {

            if (box.isEmpty) {

              return const Center(
                child: Text(
                  'Cart is Empty',
                ),
              );
            }

            return ListView.builder(

              padding: const EdgeInsets.all(12),

              itemCount: box.length,

              itemBuilder:
                  (BuildContext context,
                      int index) {

                final reversedIndex =
                    box.length - 1 - index;

                final rawItem =
                    box.getAt(reversedIndex);

                if (rawItem == null ||
                    rawItem is! Map) {

                  return const SizedBox();
                }

                final item =
                    Map<String, dynamic>.from(
                  rawItem,
                );

                return GestureDetector(

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                            WatchesDetailsScreen(
                          product: item,
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

                    decoration:
                        BoxDecoration(

                      color:
                          Theme.of(context)
                              .cardColor,

                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),

                      boxShadow: [

                        BoxShadow(

                          color:
                              Colors.black12,

                          blurRadius: 5,

                          offset:
                              const Offset(
                            0,
                            3,
                          ),
                        ),
                      ],
                    ),

                    child: Row(

                      children: [

                        /// IMAGE
                        ClipRRect(

                          borderRadius:
                              BorderRadius.circular(
                            15,
                          ),

                          child: Image.asset(

                            item['image'] ??
                                'assets/images/placeholder.png',

                            width: 90,

                            height: 90,

                            fit: BoxFit.cover,

                            errorBuilder:
                                (
                                  context,
                                  error,
                                  stackTrace,
                                ) {

                              return const Icon(
                                Icons.image,
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 15),

                        /// DETAILS
                        Expanded(

                          child: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              Text(

                                item['name'] ??
                                    'No Name',

                                style:
                                    const TextStyle(

                                  fontSize: 18,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(

                                "₹${item['price'] ?? 0}",

                                style:
                                    const TextStyle(

                                  fontSize: 16,

                                  color: Colors.blue,

                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 12),

                              /// QUANTITY UI
                              Row(

                                children: [

                                  Container(

                                    decoration:
                                        BoxDecoration(

                                      color:
                                          Colors.grey.shade300,

                                      borderRadius:
                                          BorderRadius.circular(
                                        10,
                                      ),
                                    ),

                                    child:
                                        const Padding(

                                      padding:
                                          EdgeInsets.all(
                                        5,
                                      ),

                                      child: Icon(
                                        Icons.remove,
                                        size: 18,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  const Text(

                                    "1",

                                    style:
                                        TextStyle(

                                      fontSize: 16,

                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Container(

                                    decoration:
                                        BoxDecoration(

                                      color: Colors.blue,

                                      borderRadius:
                                          BorderRadius.circular(
                                        10,
                                      ),
                                    ),

                                    child:
                                        const Padding(

                                      padding:
                                          EdgeInsets.all(
                                        5,
                                      ),

                                      child: Icon(

                                        Icons.add,

                                        size: 18,

                                        color:
                                            Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        /// DELETE BUTTON
                        IconButton(

                          onPressed: () {

                            box.deleteAt(
                              reversedIndex,
                            );
                          },

                          icon: const Icon(

                            Icons.delete,

                            color: Colors.red,
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
      ),
    );
  }
}