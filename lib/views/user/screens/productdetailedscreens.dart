import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/user/screens/cart.dart';
import 'package:mgcollection_app/views/user/screens/checkoutpage.dart';
import 'package:mgcollection_app/views/user/screens/favoriteScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController reviewController = TextEditingController();

  int quantity = 1;
  double userRating = 5;
  bool isFavorite = false;
  List<Map<String, dynamic>> reviews = [];

  // Size options per category
  List<String> get sizeOptions {
    final category =
        widget.product['category']?.toString().toLowerCase() ?? '';
    if (category == 'shoes') return ['38', '39', '40', '41', '42'];
    if (category == 'shirt' || category == 'pants')
      return ['S', 'M', 'L', 'XL'];
    return [];
  }

  String selectedSize = '';

  @override
  void initState() {
    super.initState();
    loadReviews();
    checkFavorite();
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  Future<void> checkFavorite() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    try {
      final data = await supabase
          .from('favorites')
          .select('id')
          .eq('user_id', user.id)
          .eq('product_id', widget.product['id'])
          .maybeSingle();
      if (!mounted) return;
      setState(() => isFavorite = data != null);
    } catch (_) {}
  }

  Future<void> loadReviews() async {
    try {
      final data = await supabase
          .from('productreviews')
          .select()
          .eq('product_id', widget.product['id'])
          .order('created_at', ascending: false);
      if (!mounted) return;
      setState(() {
        reviews = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      print('Load reviews error: $e');
    }
  }

  Future<void> submitReview() async {
    final reviewText = reviewController.text.trim();
    if (reviewText.isEmpty) return;

    try {
      final user = supabase.auth.currentUser;
      await supabase.from('productreviews').insert({
        'product_id': widget.product['id'],
        'user_name': user?.email?.split('@')[0] ?? 'Customer',
        'rating': userRating.toInt(),
        'review': reviewText,
      });
      if (!mounted) return;
      setState(() {
        reviews.insert(0, {
          'user_name': user?.email?.split('@')[0] ?? 'Customer',
          'rating': userRating.toInt(),
          'review': reviewText,
        });
      });
      reviewController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted ')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> toggleFavorite() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login first')),
      );
      return;
    }

    try {
      if (isFavorite) {
        await supabase
            .from('favorites')
            .delete()
            .eq('user_id', user.id)
            .eq('product_id', widget.product['id']);
        if (!mounted) return;
        setState(() => isFavorite = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from Favorites')),
        );
      } else {
        await supabase.from('favorites').insert({
          'user_id': user.id,
          'product_id': widget.product['id'],
          'product_name': widget.product['name'],
          'price': widget.product['price'],
          'image': widget.product['image'],
          'description': widget.product['description'] ?? '',
          'rating': widget.product['rating'] ?? 0,
          'category': widget.product['category'] ?? '',
        });
        if (!mounted) return;
        setState(() => isFavorite = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Added to Favorites '),
            action: SnackBarAction(
              label: 'View',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> addToCart() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login first')),
      );
      return;
    }

    try {
      await supabase.from('cart').insert({
        'user_id': user.id,
        'product_id': widget.product['id'],
        'quantity': quantity,
        'product_name': widget.product['name'],
        'price': widget.product['price'],
        'image': widget.product['image'],
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Added to Cart '),
          action: SnackBarAction(
            label: 'View Cart',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Cart()),
            ),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void buyNow() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Checkoutpage(
          product: {
            'id': widget.product['id'],
            'name': widget.product['name'],
            'price': widget.product['price'],
            'image': widget.product['image'],
            'quantity': quantity,
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rating = widget.product['rating'] ?? 0;
    final sizes = sizeOptions;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── PRODUCT IMAGE ──
            Stack(
              children: [
                Image.network(
                  widget.product['image']?.toString() ?? '',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 300,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 80),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 10,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 10,
                  child: GestureDetector(
                    onTap: toggleFavorite,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NAME + PRICE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.product['name']?.toString() ?? '',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '₹${widget.product['price'] ?? 0}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5DA9E9),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // CATEGORY BADGE
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          widget.product['category']?.toString() ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      
                      Text(
                        widget.product['description']?.toString() ?? '',
                        style: TextStyle(
                          height: 1.6,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 16),

                      
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '  (${reviews.length} reviews)',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade500),
                          ),
                        ],
                      ),

                      
                      if (sizes.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Text(
                          'Select Size',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: sizes.map((size) {
                            final isSelected = selectedSize == size;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => selectedSize = size),
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF5DA9E9)
                                      : (isDark
                                          ? Colors.grey.shade700
                                          : Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  size,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : null,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],

                      const SizedBox(height: 20),

                      
                      const Text(
                        'Quantity',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (quantity > 1)
                                setState(() => quantity--);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.remove),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              '$quantity',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (quantity < 5) {
                                setState(() => quantity++);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Maximum 5 allowed')),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF5DA9E9),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.add,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      
                      const Text(
                        'Reviews',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 12),

                      
                      Row(
                        children: List.generate(5, (i) {
                          return GestureDetector(
                            onTap: () =>
                                setState(() => userRating = (i + 1).toDouble()),
                            child: Icon(
                              i < userRating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 28,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 10),

                      TextField(
                        controller: reviewController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Write your review...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: submitReview,
                          child: const Text('Submit Review'),
                        ),
                      ),

                      const SizedBox(height: 16),

                    
                      if (reviews.isEmpty)
                        Center(
                          child: Text(
                            'No reviews yet. Be the first!',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        )
                      else
                        ...reviews.map((review) => Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Colors.blue.shade100,
                                  child: Text(
                                    (review['user_name'] ?? 'C')
                                        .toString()
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.blue.shade700),
                                  ),
                                ),
                                title: Text(
                                  review['user_name']?.toString() ??
                                      'Customer',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                    review['review']?.toString() ?? ''),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                        '${review['rating'] ?? 0}'),
                                  ],
                                ),
                              ),
                            )),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.08),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: addToCart,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey.shade700
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text(
                            'Add to Cart',
                            style:
                                TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: buyNow,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5DA9E9),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text(
                            'Buy Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}