import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/user/screens/shoes_detailed_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Shoesscreen extends StatefulWidget {
  const Shoesscreen({super.key});

  @override
  State<Shoesscreen> createState() => _ShoesscreenState();
}

class _ShoesscreenState extends State<Shoesscreen> {
  final supabase = Supabase.instance.client;

  String selectedFilter = 'Default';

  Future<List<Map<String, dynamic>>> getShoes() async {
    final data = await supabase
        .from('products')
        .select()
        .eq('category', 'Shoes')
        .order('created_at', ascending: false);

    final shoes = List<Map<String, dynamic>>.from(data);

    if (selectedFilter == 'Low to High') {
      shoes.sort((a, b) {
        final priceA = (a['price'] as num?)?.toDouble() ?? 0.0;
        final priceB = (b['price'] as num?)?.toDouble() ?? 0.0;
        return priceA.compareTo(priceB);
      });
    } else if (selectedFilter == 'High to Low') {
      shoes.sort((a, b) {
        final priceA = (a['price'] as num?)?.toDouble() ?? 0.0;
        final priceB = (b['price'] as num?)?.toDouble() ?? 0.0;
        return priceB.compareTo(priceA);
      });
    } else if (selectedFilter == 'A-Z') {
      shoes.sort((a, b) {
        final nameA = a['name']?.toString() ?? '';
        final nameB = b['name']?.toString() ?? '';
        return nameA.compareTo(nameB);
      });
    } else if (selectedFilter == 'Rating') {
      shoes.sort((a, b) {
        final ratingA = (a['rating'] as num?)?.toDouble() ?? 0.0;
        final ratingB = (b['rating'] as num?)?.toDouble() ?? 0.0;
        return ratingB.compareTo(ratingA);
      });
    }

    return shoes;
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
                    'Shoes',
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
                future: getShoes(),
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

                  final shoes = snapshot.data ?? [];

                  if (shoes.isEmpty) {
                    return const Center(
                      child: Text('No Shoes Found'),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: shoes.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.68,
                    ),
                    itemBuilder: (context, index) {
                      final shoe = shoes[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ShoesDetailsScreen(
                                product: shoe,
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
                                      shoe['image']?.toString() ?? '',
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
                                shoe['name']?.toString() ?? 'No Name',
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
                                    (shoe['rating'] ?? 0).toString(),
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
                                    '₹${shoe['price'] ?? 0}',
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