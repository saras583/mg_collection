import 'package:flutter/material.dart';
import 'package:mgcollection_app/screens/shirt_details_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
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
    {
      "name": "Black Linen Shirt",
      
      "price": 899,
      "image": "assets/images/black_shirt.jpg",
    },
    {
      "name": " Casual Shirt",
      "price": 799,
      "image": 'assets/images/laventer.jpg',
    },
    {
      "name": "Blue Denim Shirt",
      "price": 999,
      "image": "assets/images/checkshirt.jpg",
    },
    {
      "name": "Checked Cotton Shirt",
      "price": 849,
      "image": "assets/images/black_shirt.jpg",
    },
    {
      "name": "laveder Shirt",
      "price": 950,
      "image": "assets/images/laventer.jpg",
    },
    {
      "name": "Striped Office Shirt",
      "price": 899,
      "image": "assets/images/checkshirt.jpg",
    },{
      "name": "Slim Fit Jeans",
      
      "price": 1299,
      "image": "assets/images/grey trouser.jpg",
    },
    {
      "name": "Formal Trousers",
      "price": 999,
      "image": "assets/images/next.jpg",
    },
    {"name": "Cargo Pants", "price": 1499, "image": "assets/images/next.jpg"},
    {
      "name": " spiderring",
      "price": 2999,
      "image": "assets/images/spiderring.jpg",
    },
    {
      "name": "mountainring",
      "price": 4999,
      "image": "assets/images/mountainrings.jpg",
    },
    {
      "name": "ring gravur",
      "price": 1999,
      "image": "assets/images/Ring  Gravur.jpg",
    },{
      "name": "Face Cleanser",
      "price": 499,
      "image": "assets/images/cetapfilne.jpg",
    },
    {
      "name": "Moisturizing Cream",
      "price": 699,
      "image": "assets/images/vitaminc serm.jpg",
    },

    {
      "name": "Sunscreen SPF 50",
      "price": 599,
      "image": "assets/images/sunscreen.jpg",
    },
    {
      "name": "Face Wash Gel",
      "price": 399,
      "image": "assets/images/simplefacewash.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    "Best Sellers",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Icon(Icons.tune),
                      SizedBox(width: 10),
                      Icon(Icons.search),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(12),
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];

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
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// IMAGE
                          Expanded(
                            child: Center(
                              child: Image.asset(
                                product["image"],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          /// BEST SELLER
                          Text(
                            product["name"],
                            style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodyMedium?.color),
                          ),

                          SizedBox(height: 4),

                          Text(
                            product["category"]??'no category',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          Text(
                            "\$${product["price"]}",
                            style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color),
                          ),

                          SizedBox(height: 6),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$367.76",
                                style: TextStyle(fontWeight: FontWeight.bold),
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
