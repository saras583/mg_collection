import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/user/screens/shirt_details_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShirtsScreen extends StatefulWidget {
  const ShirtsScreen({super.key});

  @override
  State<ShirtsScreen> createState() => _ShirtsScreenState();
}

class _ShirtsScreenState extends State<ShirtsScreen> {
  final supabase = Supabase.instance.client;

  String selectedFilter = 'Default';
  List<Map<String, dynamic>> shirts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchShirts();
  }

  Future<void> fetchShirts() async {
    try {
      final data = await supabase
          .from('products')
          .select()
          .eq('category', 'Shirt')
          .order('created_at', ascending: false);

      setState(() {
        shirts = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      print('Fetch shirts error: $e');
    }
  }

  void _applyFilter(String value) {
    setState(() {
      selectedFilter = value;
      switch (value) {
        case 'Low to High':
          shirts.sort((a, b) =>
              (a['price'] as num).compareTo(b['price'] as num));
          break;
        case 'High to Low':
          shirts.sort((a, b) =>
              (b['price'] as num).compareTo(a['price'] as num));
          break;
        case 'A-Z':
          shirts.sort((a, b) =>
              a['name'].toString().compareTo(b['name'].toString()));
          break;
        case 'Rating':
          shirts.sort((a, b) =>
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
                      // ✅ Back button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_ios_new,
                              size: 16),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Shirts",
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
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'Low to High',
                            child: Text('Price: Low to High'),
                          ),
                          const PopupMenuItem(
                            value: 'High to Low',
                            child: Text('Price: High to Low'),
                          ),
                          const PopupMenuItem(
                            value: 'A-Z',
                            child: Text('Name: A-Z'),
                          ),
                          const PopupMenuItem(
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
                  : shirts.isEmpty
                      ? const Center(child: Text('No Shirts Found'))
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: shirts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.68,
                          ),
                          itemBuilder: (context, index) {
                            final shirt = shirts[index];

                            return GestureDetector(
                              onTap: () {
                                // ✅ pass correct map to ShirtDetailsScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ShirtDetailsScreen(
                                      product: shirt,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  // ✅ theme-aware color
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(isDark ? 0.3 : 0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    // IMAGE
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15),
                                        child: Image.network(
                                          shirt['image'] ?? '',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          // ✅ error handler
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                            color: isDark
                                                ? Colors.grey.shade800
                                                : Colors.grey.shade200,
                                            child: const Center(
                                              child: Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey),
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

                                    const SizedBox(height: 10),

                                    // NAME
                                    Text(
                                      shirt['name'] ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    // CATEGORY
                                    Text(
                                      shirt['category'] ?? '',
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
                                          '${shirt['rating'] ?? 0}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 6),

                                    // PRICE + CART BUTTON
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '₹${shirt['price']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(6),
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
          ],
        ),
      ),
    );
  }
}