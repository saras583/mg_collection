import 'package:flutter/material.dart';

class ShirtsScreen extends StatelessWidget {
  const ShirtsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color.fromARGB(255, 249, 229, 229),
      body: SafeArea(child: Column(
        children: [
          Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(12),
                itemCount: 2,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  

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
                              '',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        /// BEST SELLER
                        Text(
                         '',
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
                  );
                },
              ),
            ),
        ],
      )),
    );
  }
}
