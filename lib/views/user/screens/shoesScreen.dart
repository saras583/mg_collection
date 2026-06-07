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
  List<Map<String, dynamic>> shoes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchShoes();
  }

  Future<void> fetchShoes() async {
    try {
      final data = await supabase
          .from('products')
          .select()
          .eq('category', 'Shoes')
          .order('created_at', ascending: false);

      setState(() {
        shoes = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      print('Fetch shoes error: $e');
    }
  }

  void _applyFilter(String value) {
    setState(() {
      selectedFilter = value;
      switch (value) {
        case 'Low to High':
          shoes.sort((a, b) =>
              (a['price'] as num).compareTo(b['price'] as num));
          break;
        case 'High to Low':
          shoes.sort((a, b) =>
              (b['price'] as num).compareTo(a['price'] as num));
          break;
        case 'A-Z':
          shoes.sort((a, b) =>
              a['name'].toString().compareTo(b['name'].toString()));
          break;
        case 'Rating':
          shoes.sort((a, b) =>
              (b['rating'] as num).compareTo(a['rating'] as num));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── TOP BAR ──
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                              Icons.arrow_back_ios_new, size: 16),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Shoes',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.tune),
                        onSelected: _applyFilter,
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

            // ── GRID ──
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : shoes.isEmpty
                      ? const Center(child: Text('No Shoes Found'))
                      : RefreshIndicator(
                          onRefresh: fetchShoes,
                          child: GridView.builder(
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
                                        color: Colors.black.withOpacity(
                                            isDark ? 0.3 : 0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // IMAGE
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? Colors.grey.shade800
                                                : Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(18),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            child: Image.network(
                                              shoe['image']?.toString() ?? '',
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  Center(
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                              loadingBuilder:
                                                  (_, child, progress) {
                                                if (progress == null)
                                                  return child;
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          strokeWidth: 2),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 10),

                                      // NAME
                                      Text(
                                        shoe['name']?.toString() ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      // CATEGORY
                                      Text(
                                        shoe['category']?.toString() ?? '',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      // RATING
                                      Row(
                                        children: [
                                          const Icon(Icons.star,
                                              color: Colors.orange, size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${shoe['rating'] ?? 0}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 8),

                                      // PRICE + CART
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '₹${shoe['price'] ?? 0}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(7),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Icon(
                                              Icons.shopping_bag_outlined,
                                              color: isDark
                                                  ? Colors.black
                                                  : Colors.white,
                                              size: 16,
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
            ),
          ],
        ),
      ),
    );
  }
}