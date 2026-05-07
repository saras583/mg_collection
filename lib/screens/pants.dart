import 'package:flutter/material.dart';
import 'package:mgcollection_app/screens/pants_detailed_screen.dart';

class PantsScreen extends StatefulWidget {
  const PantsScreen({super.key});

  @override
  State<PantsScreen> createState() => _PantsScreenState();
}

class _PantsScreenState extends State<PantsScreen> {

  String selectedFilter = 'Default';

  List<Map<String, dynamic>> pants = [
    {
      "name": "Slim Fit Jeans",
      
      "price": 1299,
      "image": "assets/images/grey trouser.jpg",
     ' rating': 4.5
    },
    {
      "name": "Formal Trousers",
      "price": 999,
      "image": "assets/images/next.jpg",
      "rating": 4.5,
    },
    {"name": "Cargo Pants", "price": 1499, "image": "assets/images/next.jpg"},
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
                    "Pants",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      PopupMenuButton<String>(
  icon: Icon(Icons.tune),
  onSelected: (value) {
    setState(() {
      selectedFilter = value;

      if (value == 'Low to High') {
        pants.sort((a, b) => a['price'].compareTo(b['price']));
      } else if (value == 'High to Low') {
        pants.sort((a, b) => b['price'].compareTo(a['price']));
      } else if (value == 'A-Z') {
        pants.sort((a, b) => a['name'].compareTo(b['name']));
      }
    });
  },
  itemBuilder: (context) => [
    PopupMenuItem(
      value: 'Low to High',
      child: Text('Price: Low to High'),
    ),
    PopupMenuItem(
      value: 'High to Low',
      child: Text('Price: High to Low'),
    ),
    PopupMenuItem(
      value: 'A-Z',
      child: Text('Name: A-Z'),
    ),
    PopupMenuItem(
      value: 'lowrating-highrating',
      child: Text('Name: -Z'),
    ),
    
    
  ],
),
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
                  final pant = pants[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PantsDetailsScreen(product: pant),
                        ),
                      );
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
                                pant['image'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          /// BEST SELLER
                          Text(
                            '${pant['name']}',
                            style: TextStyle(fontSize: 10, color: Colors.blue),
                          ),

                          SizedBox(height: 4),

                          Text(
                            '${pant['price']}',
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
