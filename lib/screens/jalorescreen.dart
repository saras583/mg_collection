import 'package:flutter/material.dart';
import 'package:mgcollection_app/screens/joloredetailedscreens.dart';

class Jalorescreen extends StatefulWidget {
  const Jalorescreen({super.key});

  @override
  State<Jalorescreen> createState() => _JalorescreenState();
}

class _JalorescreenState extends State<Jalorescreen> {
  List<Map<String, dynamic>> jewellery = [
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
                    "Jolors",
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
                itemCount: jewellery.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final juloreList = jewellery[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => JewelleryDetailsScreen(product: juloreList),
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
                                juloreList['image'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          /// BEST SELLER
                          Text(
                            juloreList['name'],
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
