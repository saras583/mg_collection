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

  String selectedFilter = 'Default';
  String _orderBy = 'id';
  bool _ascending = true;

  static const int _pageSize = 6;
  int _currentPage = 1; // 1-based for display
  int _totalPages = 1;
  bool _isLoading = false;

  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _loadPage(1);
  }

  /// 
  Future<void> _loadPage(int page) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final from = (page - 1) * _pageSize;
      final to = from + _pageSize - 1;

      // Fetch count and data in parallel
      final countResponse = await supabase
          .from('products')
          .select('id')
          .order(_orderBy, ascending: _ascending);

      final dataResponse = await supabase
          .from('products')
          .select()
          .order(_orderBy, ascending: _ascending)
          .range(from, to);

      final total = (countResponse as List).length;
      final list = List<Map<String, dynamic>>.from(dataResponse);

      setState(() {
        _products = list;
        _currentPage = page;
        _totalPages = (total / _pageSize).ceil().clamp(1, 9999);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
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
    });
    _loadPage(1);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                    "Best Sellers",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
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

            
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _products.isEmpty
                      ? const Center(child: Text('No products found'))
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          itemCount: _products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.68,
                          ),
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ShirtDetailsScreen(product: product),
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
                                        isDark ? 0.3 : 0.05,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            product['image'] ?? '',
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Icon(
                                              Icons.image_not_supported_outlined,
                                              color: Colors.grey.shade400,
                                            ),
                                            loadingBuilder:
                                                (_, child, progress) {
                                              if (progress == null) return child;
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
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

                                    //catrogry
                                    Text(
                                      product['category'] ?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    //rating
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.orange,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '${product['rating'] ?? 0}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 10),

                                    //price
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.shopping_bag_outlined,
                                            color: isDark
                                                ? Colors.black
                                                : Colors.white,
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

            //paginnation
            if (!_isLoading)
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // PREV button
                    _NavButton(
                      icon: Icons.chevron_left,
                      enabled: _currentPage > 1,
                      onTap: () => _loadPage(_currentPage - 1),
                      isDark: isDark,
                    ),

                    const SizedBox(width: 8),

                    
                    ..._buildPageNumbers(isDark),

                    const SizedBox(width: 8),

                    // 
                    _NavButton(
                      icon: Icons.chevron_right,
                      enabled: _currentPage < _totalPages,
                      onTap: () => _loadPage(_currentPage + 1),
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageNumbers(bool isDark) {
    final List<Widget> widgets = [];

    // Which page numbers to show
    final Set<int> pagesToShow = {};
    pagesToShow.add(1);
    pagesToShow.add(_totalPages);
    for (int i = _currentPage - 1; i <= _currentPage + 1; i++) {
      if (i >= 1 && i <= _totalPages) pagesToShow.add(i);
    }

    final sorted = pagesToShow.toList()..sort();

    int? prev;
    for (final page in sorted) {
      // Add ellipsis if there's a gap
      if (prev != null && page - prev > 1) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '',
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }

      final isActive = page == _currentPage;
      widgets.add(
        GestureDetector(
          onTap: isActive ? null : () => _loadPage(page),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 38,
            height: 38,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF5DA9E9)
                  : isDark
                      ? Colors.grey.shade800
                      : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              '$page',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isActive
                    ? Colors.white
                    : isDark
                        ? Colors.white
                        : Colors.black87,
              ),
            ),
          ),
        ),
      );

      prev = page;
    }

    return widgets;
  }
}


class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final bool isDark;

  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFF5DA9E9)
              : isDark
                  ? Colors.grey.shade800
                  : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 20,
          color: enabled
              ? Colors.white
              : isDark
                  ? Colors.grey.shade600
                  : Colors.grey.shade400,
        ),
      ),
    );
  }
}