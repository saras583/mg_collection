import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/user/screens/shirt_details_screen.dart';
import 'package:mgcollection_app/views/user/screens/shoes_detailed_screen.dart';
import 'package:mgcollection_app/views/user/screens/watches_details_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({
    super.key,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final supabase = Supabase.instance.client;

  bool isLoading = true;
  List<Map<String, dynamic>> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final data = await supabase
          .from('favorites')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      if (!mounted) return;

      setState(() {
        favorites = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> deleteFavorite(int index) async {
    final item = favorites[index];

    try {
      await supabase
          .from('favorites')
          .delete()
          .eq('id', item['id']);

      if (!mounted) return;

      setState(() {
        favorites.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from Favorites')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void openProductDetails(Map<String, dynamic> item) {
    final product = {
      'id': item['product_id'],
      'name': item['product_name'],
      'price': item['price'],
      'image': item['image'],
      
      
      'category': item['category'],
    };

    final category = item['category']?.toString().toLowerCase() ?? '';
    final name = item['product_name']?.toString().toLowerCase() ?? '';

    if (category.contains('watch') || name.contains('watch')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WatchesDetailsScreen(product: product),
        ),
      );
    } else if (category.contains('shoe') || name.contains('shoe')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ShoesDetailsScreen(product: product),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ShirtDetailsScreen(product: product),
        ),
      );
    }
  }

  Widget productImage(String image) {
    if (image.startsWith('http')) {
      return Image.network(
        image,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return imagePlaceholder();
        },
      );
    }

    return Image.asset(
      image,
      width: 90,
      height: 90,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return imagePlaceholder();
      },
    );
  }

  Widget imagePlaceholder() {
    return Container(
      width: 90,
      height: 90,
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.image,
        color: Colors.grey,
        size: 35,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favorites.isEmpty
              ? const Center(
                  child: Text(
                    'No favorites yet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final item = favorites[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => openProductDetails(item),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: productImage(
                                item['image']?.toString() ?? '',
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => openProductDetails(item),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['product_name']?.toString() ??
                                        'No Name',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '₹${item['price'] ?? 0}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Favorite',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              deleteFavorite(index);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}