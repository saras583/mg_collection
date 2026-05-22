import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mgcollection_app/views/user/screens/shirt_details_screen.dart';
import 'package:mgcollection_app/views/user/screens/shoes_detailed_screen.dart';
import 'package:mgcollection_app/views/user/screens/watches_details_screen.dart';

class FavoritesScreen extends StatefulWidget {

  const FavoritesScreen({
    super.key,
  });

  @override
  State<FavoritesScreen> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState
    extends State<FavoritesScreen> {

  @override
  Widget build(BuildContext context) {

    var favBox =
        Hive.box('favorites');

    return Scaffold(

      appBar: AppBar(

        leading: IconButton(

          icon:
              const Icon(
            Icons.arrow_back,
          ),

          onPressed: () {

            Navigator.pop(
              context,
            );
          },
        ),

        title:
            const Text(
          "Favorites",
        ),
      ),

      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

      body: ValueListenableBuilder(

        valueListenable:
            favBox.listenable(),

        builder:
            (context, Box box, _) {

          if (box.isEmpty) {

            return const Center(

              child: Text(
                "No favorites yet",
              ),
            );
          }

          return ListView.builder(

            padding:
                const EdgeInsets.all(
              12,
            ),

            itemCount:
                box.length,

            itemBuilder:
                (context, index) {

              final reversedIndex =
                  box.length -
                      1 -
                      index;

              final rawItem =
                  box.getAt(
                reversedIndex,
              );

              if (rawItem ==
                      null ||
                  rawItem
                      is! Map) {

                return const SizedBox();
              }

              final item =
                  Map<String,
                      dynamic>.from(
                rawItem,
              );

              return GestureDetector(

                onTap: () {

                  if (item['name'] ==
                      'Watch') {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                            WatchesDetailsScreen(
                          product:
                              item,
                        ),
                      ),
                    );

                  } else if (item['name'] ==
                      'Nike Jordan') {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                            ShoesDetailsScreen(
                          product:
                              item,
                        ),
                      ),
                    );

                  } else {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                            ShirtDetailsScreen(
                          product:
                              item,
                        ),
                      ),
                    );
                  }
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

                        blurRadius:
                            5,

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

                        child:
                            Image.asset(

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

                      const SizedBox(
                        width: 15,
                      ),

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

                                fontSize:
                                    18,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Text(

                              "₹${item['price'] ?? 0}",

                              style:
                                  const TextStyle(

                                fontSize:
                                    16,

                                color:
                                    Colors.blue,

                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            /// FAVORITE TEXT
                            Container(

                              padding:
                                  const EdgeInsets.symmetric(

                                horizontal: 12,

                                vertical: 6,
                              ),

                              decoration:
                                  BoxDecoration(

                                color:
                                    Colors.red.shade100,

                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),
                              ),

                              child:
                                  const Text(

                                "Favorite",

                                style:
                                    TextStyle(

                                  color:
                                      Colors.red,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
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

                          Icons.favorite,

                          color: Colors.red,

                          size: 30,
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