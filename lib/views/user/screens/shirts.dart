import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/admin/screens/product_detailed_screen.dart';
import 'package:mgcollection_app/views/user/screens/shirt_details_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mgcollection_app/models/product_model.dart';



  class ShirtsScreen extends StatefulWidget {

  const ShirtsScreen({
    super.key,
  });

  @override
  State<ShirtsScreen> createState() =>
      _ShirtsScreenState();
}
  
  
  

  @override
  State<ShirtsScreen> createState() =>
      _ShirtsScreenState();

class _ShirtsScreenState
    extends State<ShirtsScreen> {

  String selectedFilter = "Default";
  


  final supabase = Supabase.instance.client;
  
  Future<List<Map<String, dynamic>>> getShirts() async {

  final data = await supabase
      .from('products')
      .select()
      .eq('category', 'Shirt')
      .order(
        'created_at',
        ascending: false,
      );

  return List<Map<String, dynamic>>
      .from(data);
}

  

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

    selectedFilter = value;

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
  child: FutureBuilder<List<Map<String, dynamic>>>(

    future: getShirts(),

    builder: (context, snapshot) {

      if (snapshot.connectionState ==
          ConnectionState.waiting) {

        return const Center(
          child:
              CircularProgressIndicator(),
        );
      }

      if (snapshot.hasError) {

        return Center(
          child: Text(
            snapshot.error.toString(),
          ),
        );
      }

      final shirts =
          snapshot.data ?? [];

      if (shirts.isEmpty) {

        return const Center(
          child: Text(
            "No Shirts Found",
          ),
        );
      }

      return GridView.builder(

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

      builder: (_) => ShirtDetailsScreen(product: product)
    ),
  );
},

            child: Container(
              padding: const EdgeInsets.all(12),

decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(20),
),

child: Column(
  children: [

    Expanded(
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(15),

        child: Image.network(
          shirtsList['image'],
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    ),

    const SizedBox(height: 10),

    Text(
      shirtsList['name'],
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),

    Text(
      "₹${shirtsList['price']}",
    ),
  ],
),
              // Keep your existing UI
            ),
          );
        },
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