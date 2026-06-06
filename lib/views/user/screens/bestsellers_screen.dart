import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/user/screens/shirt_details_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final supabase = Supabase.instance.client;
  final ScrollController _scrollController = ScrollController();

  String selectedFilter = 'Default';
  String _orderBy = 'id';
  bool _ascending = true;

  static const int _pageSize = 6;
  int _currentPage = 0;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _loadNextPage();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      _loadNextPage();
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() => _isLoadingMore = true);

    try {
      final from = _currentPage * _pageSize;
      final to = from + _pageSize - 1;

      final data = await supabase
          .from('products')
          .select()
          .order(_orderBy, ascending: _ascending)
          .range(from, to);

      final list = List<Map<String, dynamic>>.from(data);

      setState(() {
        _products.addAll(list);
        _currentPage++;
        _hasMore = list.length == _pageSize;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() => _isLoadingMore = false);
      print('Error loading products: $e');
    }
  }

  void _applyFilter(String value) {
    setState(() {
      selectedFilter = value;
      switch (value) {
        case 'Low to High':
          _orderBy = 'price';
          _ascending = true;
          break;
        case 'High to Low':
          _orderBy = 'price';
          _ascending = false;
          break;
        case 'A-Z':
          _orderBy = 'name';
          _ascending = true;
          break;
        case 'Rating':
          _orderBy = 'rating';
          _ascending = false;
          break;
        default:
          _orderBy = 'id';
          _ascending = true;
      }
      // Reset and reload
      _currentPage = 0;
      _products = [];
      _hasMore = true;
    });
    _loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Best Sellers",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.tune),
                        onSelected: _applyFilter,
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'Low to High', child: Text('Price: Low to High')),
                          const PopupMenuItem(value: 'High to Low', child: Text('Price: High to Low')),
                          const PopupMenuItem(value: 'A-Z', child: Text('Name: A-Z')),
                          const PopupMenuItem(value: 'Rating', child: Text('Top Rated')),
                        ],
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.search),
                    ],
                  ),
                ],
              ),
            ),

            // PRODUCTS GRID
            Expanded(
              child: _products.isEmpty && !_isLoadingMore
                  ? const Center(child: Text('No products found'))
                  : GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: _products.length + (_isLoadingMore ? 2 : 0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.68,
                      ),
                      itemBuilder: (context, index) {
                        // Loading placeholder cards
                        if (index >= _products.length) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }

                        final product = _products[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ShirtDetailsScreen(product: product),
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
                                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // IMAGE — now using network URL
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Image.network(
                                        product['image'] ?? '',
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(
                                          Icons.image_not_supported_outlined,
                                          color: Colors.grey.shade400,
                                        ),
                                        loadingBuilder: (_, child, progress) {
                                          if (progress == null) return child;
                                          return const Center(
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // NAME
                                Text(
                                  product['name'] ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                // CATEGORY
                                Text(
                                  product['category'] ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                // RATING
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.orange, size: 16),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${product['rating'] ?? 0}',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                // PRICE + BUTTON
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '₹${product['price']}',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: isDark ? Colors.white : Colors.black,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.shopping_bag_outlined,
                                        color: isDark ? Colors.black : Colors.white,
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
                    ),
            ),

            // BOTTOM COUNT
            if (!_isLoadingMore && !_hasMore && _products.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Showing all ${_products.length} products',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}