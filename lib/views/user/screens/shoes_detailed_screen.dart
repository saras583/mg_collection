import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/user/screens/cart.dart';
import 'package:mgcollection_app/views/user/screens/checkoutpage.dart';
import 'package:mgcollection_app/views/user/screens/favoriteScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShoesDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ShoesDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ShoesDetailsScreen> createState() => _ShoesDetailsScreenState();
}

class _ShoesDetailsScreenState extends State<ShoesDetailsScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController reviewController = TextEditingController();

  int quantity = 1;
  double userRating = 5;
  bool isFavorite = false;
  List<Map<String, dynamic>> reviews = [];

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

    final data = await supabase
        .from('favorites')
        .select('id')
        .eq('user_id', user.id)
        .eq('product_id', widget.product['id'])
        .maybeSingle();

    if (!mounted) return;

    setState(() {
      isFavorite = data != null;
    });
  }

  Future<void> loadReviews() async {
    try {
      final data = await supabase
          .from('productreviews')
          .select()
          .eq('product_id', widget.product['id']);

      if (!mounted) return;

      setState(() {
        reviews = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> submitReview() async {
    final reviewText = reviewController.text.trim();

    if (reviewText.isEmpty) return;

    try {
      await supabase.from('productreviews').insert({
        'product_id': widget.product['id'],
        'user_name': 'Customer',
        'rating': userRating.toInt(),
        'review': reviewText,
      });

      if (!mounted) return;

      setState(() {
        reviews.add({
          'user_name': 'Customer',
          'rating': userRating.toInt(),
          'review': reviewText,
        });
      });

      reviewController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully')),
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

        setState(() {
          isFavorite = false;
        });

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
          'description': widget.product['description'],
          'rating': widget.product['rating'],
          'category': widget.product['category'] ?? 'Shoes',
        });

        if (!mounted) return;

        setState(() {
          isFavorite = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Added to Favorites'),
            action: SnackBarAction(
              label: 'View',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FavoritesScreen(),
                  ),
                );
              },
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

  Future<void> addToCart(BuildContext context) async {
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
          content: const Text('Added to Cart'),
          action: SnackBarAction(
            label: 'View Cart',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Cart()),
              );
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void buyNow(BuildContext context) {
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
    final rating = widget.product['rating'] ?? 0;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  widget.product['image']?.toString() ?? '',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 300,
                      child: Center(
                        child: Icon(Icons.broken_image, size: 80),
                      ),
                    );
                  },
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product['name']?.toString() ?? '',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '₹${widget.product['price'] ?? 0}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        widget.product['description']?.toString() ??
                            'High-quality running shoes for comfort and performance.',
                        style: const TextStyle(height: 1.5),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _sizeBox('38'),
                          _sizeBox('39'),
                          _sizeBox('40'),
                          _sizeBox('41'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 8),
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        'Quantity',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.remove),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            quantity.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              if (quantity < 5) {
                                setState(() {
                                  quantity++;
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Maximum 5 allowed'),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Reviews',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: reviewController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Write your review.',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: submitReview,
                        child: const Text('Submit Review'),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: reviews.map((review) {
                          return ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(
                              (review['user_name'] ?? 'Customer').toString(),
                            ),
                            subtitle: Text(
                              (review['review'] ?? '').toString(),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text((review['rating'] ?? '').toString()),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => addToCart(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text(
                            'Add to Cart',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => buyNow(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.blue,
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

  Widget _sizeBox(String size) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(size),
    );
  }
}