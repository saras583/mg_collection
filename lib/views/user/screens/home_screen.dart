import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mgcollection_app/models/categories_items.dart';
import 'package:mgcollection_app/models/product_model.dart';
import 'package:mgcollection_app/services/product_service.dart';
import 'package:mgcollection_app/views/user/screens/cart.dart';
import 'package:mgcollection_app/views/user/screens/favoriteScreen.dart';
import 'package:mgcollection_app/views/user/screens/jalorescreen.dart';
import 'package:mgcollection_app/views/user/screens/pants.dart';
import 'package:mgcollection_app/views/user/screens/productdetailedscreens.dart';
import 'package:mgcollection_app/views/user/screens/shirts.dart';
import 'package:mgcollection_app/views/user/screens/shoesScreen.dart';
import 'package:mgcollection_app/views/user/screens/skincareScreen.dart';
import 'package:mgcollection_app/views/user/screens/walletscreen.dart';
import 'package:mgcollection_app/views/user/screens/watches.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFavorite = false;
  final productService = ProductService();

  List<ProductModel> _products = [];
  bool _productsLoading = true;

  final List<Category> categories = [
    Category(name: "Shirt", image: "assets/images/shirt.jpg"),
    Category(name: "Watch", image: "assets/images/watch.jpg"),
    Category(name: "Skincare", image: "assets/images/skincare.jpg"),
    Category(name: "Pants", image: "assets/images/next.jpg"),
    Category(name: "Shoes", image: "assets/images/air1.jpg"),
    Category(name: "jalore", image: "assets/images/jalore.jpg"),
  ];

  List<Map<String, dynamic>> _banners = [];
  final PageController _bannerController = PageController();
  int _currentBanner = 0;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _fetchBanners();
    _fetchProducts();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await productService.fetchProducts();
      if (!mounted) return;
      setState(() {
        _products = products;
        _productsLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _productsLoading = false);
      print('Fetch products error: $e');
    }
  }

  Future<void> _fetchBanners() async {
    try {
      final data = await Supabase.instance.client
          .from('banners')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      if (!mounted) return;

      setState(() {
        _banners = List<Map<String, dynamic>>.from(data);
      });

      _bannerTimer?.cancel();

      if (_banners.length > 1) {
        _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
          if (!mounted) return;
          if (_bannerController.hasClients) {
            _currentBanner = (_currentBanner + 1) % _banners.length;
            _bannerController.animateToPage(
              _currentBanner,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    } catch (e) {
      print('Fetch banners error: $e');
    }
  }

  Future<void> _navigateToLinkedProduct(int productId) async {
    try {
      final data = await Supabase.instance.client
          .from('products')
          .select()
          .eq('id', productId)
          .single();

      if (!mounted) return;

      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: data),
        ),
      );
    } catch (e) {
      print('Navigate to product error: $e');
    }
  }

  Widget _buildBannerSlider() {
    if (_banners.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: double.infinity,
          height: 160,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Discount Products",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Get up to 50% off",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Icon(Icons.local_offer, color: Colors.white, size: 50),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 160,
        child: Stack(
          children: [
            PageView.builder(
              controller: _bannerController,
              itemCount: _banners.length,
              onPageChanged: (i) => setState(() => _currentBanner = i),
              itemBuilder: (context, index) {
                final banner = _banners[index];
                return GestureDetector(
                  onTap: () {
                    if (banner['product_id'] != null) {
                      _navigateToLinkedProduct(banner['product_id']);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      image: DecorationImage(
                        image: NetworkImage(banner['image'] ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.55),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        banner['title'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (_banners.length > 1)
              Positioned(
                bottom: 10,
                right: 12,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    _banners.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(left: 4),
                      width: _currentBanner == i ? 16 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _currentBanner == i
                            ? Colors.white
                            : Colors.white54,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MGWalletScreen()),
                          ),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.grey.shade200,
                            child: Icon(Icons.wallet,
                                color:
                                    isDark ? Colors.white : Colors.black),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "Store location",
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                              ),
                            ),
                            const Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.red, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  "Mondolibug, Sylhet",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const FavoritesScreen()),
                              ),
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.grey.shade200,
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite
                                      ? Colors.red
                                      : (isDark
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const Cart()),
                                  ),
                                  child: CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.grey.shade200,
                                    child: Icon(
                                      Icons.shopping_bag_outlined,
                                      color: Theme.of(context)
                                          .iconTheme
                                          .color,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 4,
                                  top: 4,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8),
                          child: GestureDetector(
                            onTap: () =>
                                _navigateToCategory(category.name),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      AssetImage(category.image),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  category.name,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search products",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  
                  _buildBannerSlider(),

                  const SizedBox(height: 14),

                  
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Featured Products",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_products.length} items',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),

            
            _productsLoading
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : _products.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: Text("No products found"),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final product = _products[index];
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    
                                    builder: (_) => ProductDetailScreen(
                                      product: product.toJson(),
                                    ),
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade200,
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                          child: Image.network(
                                            product.image,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            errorBuilder:
                                                (_, __, ___) => Container(
                                              color: Colors.grey.shade300,
                                              child: const Center(
                                                child: Icon(Icons
                                                    .image_not_supported),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          product.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text(
                                          product.category,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.star,
                                                color: Colors.amber,
                                                size: 16),
                                            const SizedBox(width: 4),
                                            Text(
                                              product.rating.toString(),
                                              style: const TextStyle(
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.fromLTRB(
                                                8, 4, 8, 10),
                                        child: Text(
                                          "₹${product.price}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: _products.length,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.72,
                          ),
                        ),
                      ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  void _navigateToCategory(String categoryName) {
    final routes = {
      "Shirt": const ShirtsScreen(),
      "Watch": const WatchesScreen(),
      "Pants": const PantsScreen(),
      "Shoes": const Shoesscreen(),
      "Skincare": const Skincarescreen(),
      "jalore": const Jalorescreen(),
    };
    if (routes.containsKey(categoryName)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => routes[categoryName]!),
      );
    }
  }
}