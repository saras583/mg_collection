import 'package:flutter/material.dart';
import 'package:mgcollection_app/models/categories_items.dart';
import 'package:mgcollection_app/screens/favoriteScreen.dart';
import 'package:mgcollection_app/screens/orderbagscreen.dart';
import 'package:mgcollection_app/screens/pants.dart';
import 'package:mgcollection_app/screens/shirt_details_screen.dart';
import 'package:mgcollection_app/screens/shirts.dart';
import 'package:mgcollection_app/screens/shoesScreen.dart';
import 'package:mgcollection_app/screens/skincareScreen.dart';
import 'package:mgcollection_app/screens/watches.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFavorite = false;

  List<Category> categories = [
    Category(name: "Shirt", image: "assets/images/shirt.jpg"),
    Category(name: "Watch", image: "assets/images/letstartmg.jpg"),
    Category(name: "Skincare", image: "assets/images/skincare.jpg"),
    Category(name: "Pants", image: "assets/images/next.jpg"),
    Category(name: "Shoes", image: "assets/images/air1.jpg"),
  ];
  List<Map<String, dynamic>> products = [
    {
      "name": "wathes",
      "category": "Men’s Shoes",
      "price": 367.76,
      "image": "assets/images/watch.jpg",
    },
    {
      "name": "pant",
      "category": "Men’s Shoes",
      "price": 299.99,
      "image": "assets/images/grey trouser.jpg",
    },
    {
      "name": "Nike Jordan",
      "category": "Men’s Shoes",
      "price": 399.99,
      "image": "assets/images/air1.jpg",
    },
    {
      "name": "shirt",
      "category": "Running Shoes",
      "price": 249.99,
      "image": "assets/images/black_shirt.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 229, 229),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///  (Menu)
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(Icons.grid_view, color: Colors.black),
                  ),

                  ///  LOCATION
                  Column(
                    children: [
                      Text(
                        "Store location",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Row(
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

                  /// ICONS
                  /// favoraite
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => FavoriteScreen()),
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
                      SizedBox(width: 10),

                      /// CART
                      Stack(
                        children: [
                          GestureDetector(onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_)=> Orderbagscreen() ));
                          },
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.grey.shade200,
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
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
            SizedBox(height: 10),

            /// categories
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
                      padding: EdgeInsets.symmetric(horizontal: 10),

                      child: GestureDetector(
                        child: GestureDetector(
                          onTap: () {
                            _navigateToCategory(category.name);
                          },

                          child: Column(
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(category.image),
                                  ),
                                  SizedBox(height: 5),

                                  /// CATEGORY
                                  Text(
                                    category.name,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Looking for shoes",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade200,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            //product  lists
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: products.length,

                itemBuilder: (BuildContext context, int index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ShirtDetailsScreen(product: product),
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //product image
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(10),
                              child: Image.asset(
                                product["image"],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              product["name"],
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text("\$899", textAlign: TextAlign.center),
                          ),

                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// LEFT TEXT PART
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "BEST CHOICE",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "Nike Air Jordan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text("\$849.69", style: TextStyle(fontSize: 16)),
                    ],
                  ),

                  /// RIGHT IMAGE
                  Image.asset("assets/images/air1.jpg", height: 70),
                ],
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
    };

    if (routes.containsKey(categoryName)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => routes[categoryName]!),
      );
    }
  }
}
