import 'package:flutter/material.dart';

class Shoesscreen extends StatefulWidget {
  const Shoesscreen({super.key});

  @override
  State<Shoesscreen> createState() => _ShoesscreenState();
}

class _ShoesscreenState extends State<Shoesscreen> {
  List<Map<String, dynamic>> shoes = [
  {
    "name": "Nike Air Max",
    "price": 2499,
    "image": "assets/images/shoe1.jpg",
  },
  {
    "name": "Adidas Ultraboost",
    "price": 2999,
    "image": "assets/images/shoe2.jpg",
  },
  {
    "name": "Puma Running Shoes",
    "price": 1999,
    "image": "assets/images/shoe3.jpg",
  },
  {
    "name": "Nike Jordan",
    "price": 3499,
    "image": "assets/images/shoe4.jpg",
  },
  {
    "name": "Reebok Classic",
    "price": 1799,
    "image": "assets/images/shoe5.jpg",
  },
  {
    "name": "Skechers Comfort",
    "price": 1599,
    "image": "assets/images/shoe6.jpg",
  },
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
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
                itemCount: shoes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final watch = shoes[index];

                  return Container(
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
                              watch['image'],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        /// BEST SELLER
                        Text(
                          watch['name'],
                          style: TextStyle(fontSize: 10, color: Colors.blue),
                        ),

                        SizedBox(height: 4),

                        Text(watch['price'], style: TextStyle(fontWeight: FontWeight.bold)),

                        Text(
                          '',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),

                        SizedBox(height: 6),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),);
  }
}
