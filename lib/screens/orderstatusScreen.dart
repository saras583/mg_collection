import 'package:flutter/material.dart';
import 'package:mgcollection_app/screens/orderdetailedscreen.dart';

class OrderStatusScreen extends StatelessWidget {
  const OrderStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4ECEC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              SizedBox(height: 30),

              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ESTIMATED ARRIVAL",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),

                    SizedBox(height: 8),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tomorrow, Oct 24",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            "In Transit",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              Text(
                "Shipment Journey",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              _timelineItem(
                title: "Out for Delivery",
                subtitle: "Expected by 6:00 PM",
                active: false,
              ),

              _timelineItem(
                title: "Arrived at Hub",
                subtitle: "Today, 08:42 AM",
                active: true,
              ),

              _timelineItem(
                title: "Shipped",
                subtitle: "Oct 22, 02:15 PM",
                active: true,
              ),

              _timelineItem(
                title: "Order Placed",
                subtitle: "Oct 21, 11:30 AM",
                active: true,
                isLast: true,
              ),

              Spacer(),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => OrderDetailsScreen(
      order: order,
    ),
  ),
);},
                child: Text("View Order Details"),
              ),

              SizedBox(height: 15),

              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
                child: Text("Contact Support"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timelineItem({
    required String title,
    required String subtitle,
    required bool active,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Column(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor:
                  active ? Colors.green : Colors.grey.shade300,
              child: Icon(
                Icons.check,
                size: 12,
                color: Colors.white,
              ),
            ),

            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: Colors.green,
              ),
          ],
        ),

        SizedBox(width: 15),

        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}