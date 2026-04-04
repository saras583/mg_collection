import 'package:flutter/material.dart';

class Skincarescreen extends StatefulWidget {
  const Skincarescreen({super.key});

  @override
  State<Skincarescreen> createState() => _SkincarescreenState();
}

class _SkincarescreenState extends State<Skincarescreen> {
  List<Map<String, dynamic>> skincare = [
  {
    "name": "Face Cleanser",
    "price": 499,
    "image": "assets/images/skincare1.jpg",
  },
  {
    "name": "Moisturizing Cream",
    "price": 699,
    "image": "assets/images/skincare2.jpg",
  },
  {
    "name": "Vitamin C Serum",
    "price": 899,
    "image": "assets/images/skincare3.jpg",
  },
  {
    "name": "Sunscreen SPF 50",
    "price": 599,
    "image": "assets/images/skincare4.jpg",
  },
  {
    "name": "Face Wash Gel",
    "price": 399,
    "image": "assets/images/skincare5.jpg",
  },
  {
    "name": "Night Repair Cream",
    "price": 799,
    "image": "assets/images/skincare6.jpg",
  },
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "skincare",
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
                itemCount: skincare.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final skincares = skincare[index];

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
                              skincares['image'],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        /// BEST SELLER
                        Text(
                          skincares['name'],
                          style: TextStyle(fontSize: 10, color: Colors.blue),
                        ),

                        SizedBox(height: 4),
  

                        SizedBox(height: 6),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              skincares['price'],
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
