import 'package:flutter/material.dart';

class WatchesScreen extends StatefulWidget {
  const WatchesScreen({super.key});

  @override
  State<WatchesScreen> createState() => _WatchesScreenState();
}

class _WatchesScreenState extends State<WatchesScreen> {
  List<Map<String, dynamic>> watches = [
  {
    "name": "Rolex Submariner",
    "price": 1299,
    "image": "assets/images/watch.jpg",
  },
  {
    "name": "Casio G-Shock",
    "price": 899,
    "image": 'assets/images/watch.jpg',
  },
  {
    "name": "Fossil Chronograph",
    "price": 1499,
    "image": "assets/images/watch.jpg",
  },
  {
    "name": "Titan Classic",
    "price": 999,
    "image": "assets/images/watch.jpg",
  },
  
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: 
      SafeArea(
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
                itemCount: watches.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final watch = watches[index];

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

                        Text('', style: TextStyle(fontWeight: FontWeight.bold)),

                        Text(
                          '',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
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
