import 'package:flutter/material.dart';

class PantsScreen extends StatefulWidget {
  const PantsScreen({super.key});

  @override
  State<PantsScreen> createState() => _PantsScreenState();
}

class _PantsScreenState extends State<PantsScreen> {
  List<Map<String, dynamic>> pants = [
  {
    "name": "Slim Fit Jeans",
    "price": 1299,
    "image": "assets/images/pant1.jpg",
  },
  {
    "name": "Formal Trousers",
    "price": 999,
    "image": "assets/images/pant2.jpg",
  },
  {
    "name": "Cargo Pants",
    "price": 1499,
    "image": "assets/images/pant3.jpg",
  },
  {
    "name": "Denim Blue Jeans",
    "price": 1199,
    "image": "assets/images/pant4.jpg",
  },
  {
    "name": "Chinos Pants",
    "price": 1099,
    "image": "assets/images/pant5.jpg",
  },
  {
    "name": "Jogger Pants",
    "price": 899,
    "image": "assets/images/pant6.jpg",
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
                itemCount: pants.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final watch = pants[index];

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
