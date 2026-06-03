import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/user/screens/pants_detailed_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PantsScreen extends StatefulWidget {
  const PantsScreen({super.key});

  @override
  State<PantsScreen> createState() => _PantsScreenState();
}

class _PantsScreenState extends State<PantsScreen> {
  final supabase = Supabase.instance.client;

  String selectedFilter = 'Default';

  Future<List<Map<String, dynamic>>> getPants() async {
    final data = await supabase
        .from('products')
        .select()
        .eq('category', 'Pants')
        .order('created_at', ascending: false);

    final pants = List<Map<String, dynamic>>.from(data);

    if (selectedFilter == 'Low to High') {
      pants.sort((a, b) {
        final priceA = (a['price'] as num?)?.toDouble() ?? 0.0;
        final priceB = (b['price'] as num?)?.toDouble() ?? 0.0;
        return priceA.compareTo(priceB);
      });
    } else if (selectedFilter == 'High to Low') {
      pants.sort((a, b) {
        final priceA = (a['price'] as num?)?.toDouble() ?? 0.0;
        final priceB = (b['price'] as num?)?.toDouble() ?? 0.0;
        return priceB.compareTo(priceA);
      });
    } else if (selectedFilter == 'A-Z') {
      pants.sort((a, b) {
        final nameA = a['name']?.toString() ?? '';
        final nameB = b['name']?.toString() ?? '';
        return nameA.compareTo(nameB);
      });
    } else if (selectedFilter == 'Rating') {
      pants.sort((a, b) {
        final ratingA = (a['rating'] as num?)?.toDouble() ?? 0.0;
        final ratingB = (b['rating'] as num?)?.toDouble() ?? 0.0;
        return ratingB.compareTo(ratingA);
      });
    }

    return pants;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pants',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.tune),
                        onSelected: (value) {
                          setState(() {
                            selectedFilter = value;
                          });
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'Low to High',
                            child: Text('Price: Low to High'),
                          ),
                          PopupMenuItem(
                            value: 'High to Low',
                            child: Text('Price: High to Low'),
                          ),
                          PopupMenuItem(
                            value: 'A-Z',
                            child: Text('Name: A-Z'),
                          ),
                          PopupMenuItem(
                            value: 'Rating',
                            child: Text('Top Rated'),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.search),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: getPants(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }

                  final pants = snapshot.data ?? [];

                  if (pants.isEmpty) {
                    return const Center(
                      child: Text('No Pants Found'),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: pants.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.68,
                    ),
                    itemBuilder: (context, index) {
                      final pant = pants[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PantsDetailsScreen(
                                product: pant,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.network(
                                      pant['image']?.toString() ?? '',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey.shade300,
                                          child: const Center(
                                            child: Icon(
                                              Icons.image_not_supported,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                pant['name']?.toString() ?? 'No Name',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    (pant['rating'] ?? 0).toString(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '₹${pant['price'] ?? 0}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.shopping_bag_outlined,
                                      color: Colors.white,
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