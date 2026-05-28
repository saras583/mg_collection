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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFavorite = false;

  final productService = ProductService();

  List<Category> categories = [
    Category(name: "Shirt", image: "assets/images/shirt.jpg"),
    Category(name: "Watch", image: "assets/images/watch.jpg"),
    Category(name: "Skincare", image: "assets/images/skincare.jpg"),
    Category(name: "Pants", image: "assets/images/next.jpg"),
    Category(name: "Shoes", image: "assets/images/air1.jpg"),
    Category(name: "jalore", image: "assets/images/jalore.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            /// TOP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  /// MENU
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder:  (_)=> MGWalletScreen()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey.shade200,

                      child: const Icon(Icons.wallet, color: Colors.black),
                    ),
                  ),

                  /// LOCATION
                  Column(
                    children: [
                      Text(
                        "Store location",
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),

                      const Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.red, size: 16),

                          SizedBox(width: 4),

                          Text(
                            "Mondolibug, Sylhet",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),

                  /// ACTIONS
                  Row(
                    children: [
                      /// FAVORITE
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FavoritesScreen(),
                            ),
                          );
                        },

                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey.shade200,

                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,

                            color: isFavorite ? Colors.red : Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// CART
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => Cart()),
                              );
                            },

                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.grey.shade200,

                              child: Icon(
                                Icons.shopping_bag_outlined,
                                color: Theme.of(context).iconTheme.color,
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

            /// CATEGORIES
            Padding(
              padding: const EdgeInsets.all(10),

              child: SizedBox(
                height: 100,

                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,

                  itemBuilder: (BuildContext context, int index) {
                    final category = categories[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),

                      child: GestureDetector(
                        onTap: () {
                          _navigateToCategory(category.name);
                        },

                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(category.image),
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
            ),

            const SizedBox(height: 5),

            /// SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search products",
                  prefixIcon: const Icon(Icons.search),

                  filled: true,
                  fillColor: Colors.grey.shade200,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// PRODUCTS
            Expanded(
              child: FutureBuilder<List<ProductModel>>(
                future: productService.fetchProducts(),

                builder: (context, snapshot) {
                  /// LOADING
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  /// ERROR
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  /// DATA
                  final products = snapshot.data ?? [];

                  if (products.isEmpty) {
                    return const Center(child: Text("No products found"));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),

                    itemCount: products.length,

                    itemBuilder: (context, index) {
                      final product = products[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailsScreen(product: product),
                            ),
                          );
                        },

                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,

                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              /// IMAGE
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),

                                  child: Image.network(
                                    product.image,
                                    fit: BoxFit.cover,
                                    width: double.infinity,

                                    errorBuilder: (context, error, stackTrace) {
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

                              /// PRODUCT NAME
                              Padding(
                                padding: const EdgeInsets.all(8),

                                child: Text(
                                  product.name,

                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              /// CATEGORY
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),

                                child: Text(
                                  product.category,

                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),

                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18,
                                    ),

                                    const SizedBox(width: 4),

                                    Text(
                                      product.rating.toString(),

                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// PRICE
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),

                                child: Text(
                                  "₹${product.price}",

                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),
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

  void _navigateToCategory(String categoryName) {
    final routes = {
      "Shirt": ShirtsScreen(),
      "Watch": WatchesScreen(),
      "Pants": PantsScreen(),
      "Shoes": Shoesscreen(),
      "Skincare": Skincarescreen(),
      "jalore": Jalorescreen(),
    };

    if (routes.containsKey(categoryName)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => routes[categoryName]!),
      );
    }
  }
}
