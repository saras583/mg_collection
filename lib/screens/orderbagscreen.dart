import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class Orderbagscreen extends StatelessWidget {
  const Orderbagscreen({super.key});

  @override
  Widget build(BuildContext context) {
    var orderBox = Hive.box('orders');

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: Text("My Orders"),
      ),

      body: ValueListenableBuilder(
        valueListenable: orderBox.listenable(),
        builder: (context, Box box, _) {

          
          if (box.isEmpty) {
            return Center(
              child: Text(
                "No Orders Yet ",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              var item = box.getAt(index);

              return Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Row(
                  children: [

                    /// IMAGE
                    Image.asset(
                      item['image'],
                      height: 60,
                      width: 60,
                      fit: BoxFit.contain,
                    ),

                    SizedBox(width: 10),

                    /// DETAILS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            item['name'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          ),

                          SizedBox(height: 5),

                          Text("₹${item['price']}"),

                          SizedBox(height: 5),

                          Text(
                            "Payment: ${item['payment']}",
                            style: TextStyle(color: Colors.grey),
                          ),

                          SizedBox(height: 5),

                          Text(
                            item['time'] ?? "",
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}