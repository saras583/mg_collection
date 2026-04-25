import 'package:flutter/material.dart';
import 'package:mgcollection_app/screens/shoes_detailed_screen.dart';

class Shoesscreen extends StatefulWidget {
  const Shoesscreen({super.key});

  @override
  State<Shoesscreen> createState() => _ShoesscreenState();
}

class _ShoesscreenState extends State<Shoesscreen> {
  List<Map<String, dynamic>> shoes = [
    {"name": "Nike Air Max", "price": 2499, "image": "assets/images/air1.jpg"},
    {
      "name": "Adidas Ultraboost",
      "price": 2999,
      "image": "assets/images/air1.jpg",
    },
    {
      "name": "Puma Running Shoes",
      "price": 1999,
      "image": "assets/images/air1.jpg",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "shoes",
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
                itemCount: shoes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final shoe = shoes[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShoesDetailsScreen(product: shoe),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// IMAGE
                          Expanded(
                            child: Center(
                              child: Image.asset(
                                shoe['image'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          /// BEST SELLER
                          Text(
                            '${shoe['name']}',
                            style: TextStyle(fontSize: 10, color: Colors.blue),
                          ),

                          SizedBox(height: 4),

                          Text(
                            '${shoe['price']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          Text(
                            '',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),

                          SizedBox(height: 6),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [],
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
