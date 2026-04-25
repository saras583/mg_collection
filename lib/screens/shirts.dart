import 'package:flutter/material.dart';
import 'package:mgcollection_app/screens/shirt_details_screen.dart';

class ShirtsScreen extends StatefulWidget {
  const ShirtsScreen({super.key});

  @override
  State<ShirtsScreen> createState() => _ShirtsScreenState();
}

class _ShirtsScreenState extends State<ShirtsScreen> {
  List<Map<String, dynamic>> shirts = [
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
                    "Shirts",
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
                itemCount: shirts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final shirtsList = shirts[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => ShirtDetailsScreen(product: shirtsList),
                      ));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:  Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// IMAGE
                          Expanded(
                            child: Center(
                              child: Image.asset(
                                shirtsList['image'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          /// BEST SELLER
                          Text(
                            shirtsList['name'],
                            style: TextStyle(fontSize: 10, color: Colors.blue),
                          ),

                          SizedBox(height: 4),

                          Text(
                            '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

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
