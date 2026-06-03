import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/user/screens/cancelproductscreen.dart';
import 'package:mgcollection_app/views/user/screens/orderdetailedscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderStatusScreen extends StatelessWidget {

  final Map<String, dynamic> order;

  const OrderStatusScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {

    final status =
        order["status"]?.toString() ?? "Pending";
        final canCancel =
      status != "Cancelled" &&
      status != "Completed" &&
      status != "Refund Requested";

    return Scaffold(

      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding:
                const EdgeInsets.all(20),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                /// BACK BUTTON
                CircleAvatar(

                  backgroundColor:
                      Theme.of(context)
                          .cardColor,

                  child: IconButton(

                    icon: const Icon(
                      Icons.arrow_back,
                    ),

                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                /// ORDER STATUS CARD
                Container(

                  padding:
                      const EdgeInsets.all(
                    20,
                  ),

                  decoration: BoxDecoration(

                    color:
                        Theme.of(context)
                            .cardColor,

                    borderRadius:
                        BorderRadius.circular(
                      25,
                    ),

                    boxShadow: [

                      BoxShadow(

                        color: Colors.black
                            .withOpacity(
                          0.05,
                        ),

                        blurRadius: 10,

                        offset:
                            const Offset(
                          0,
                          4,
                        ),
                      ),
                    ],
                  ),

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      const Text(

                        "ESTIMATED ARRIVAL",

                        style: TextStyle(

                          fontSize: 12,

                          color:
                              Colors.grey,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Row(

                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

                        children: [

                          const Expanded(

                            child: Text(

                              "Tomorrow, Oct 24",

                              style: TextStyle(

                                fontSize: 22,

                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),

                          /// STATUS
                          Container(

                            padding:
                                const EdgeInsets.symmetric(
                              horizontal:
                                  14,
                              vertical: 8,
                            ),

                            decoration:
                                BoxDecoration(

                              color:

                                  status ==
                                          "Completed"

                                      ? Colors
                                          .green

                                      : status ==
                                              "Cancelled"

                                          ? Colors
                                              .red

                                          : Colors
                                              .orange,

                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),
                            ),

                            child: Text(

                              status,

                              style:
                                  const TextStyle(

                                color:
                                    Colors
                                        .white,

                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                /// TITLE
                const Text(

                  "Shipment Journey",

                  style: TextStyle(

                    fontSize: 20,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                /// TIMELINE
                _timelineItem(

                  title:
                      "Out for Delivery",

                  subtitle:
                      "Expected by 6:00 PM",

                  active:
                      status == "Completed",
                ),

                _timelineItem(

                  title:
                      "Arrived at Hub",

                  subtitle:
                      "Today, 08:42 AM",

                  active: true,
                ),

                _timelineItem(

                  title: "Shipped",

                  subtitle:
                      "Oct 22, 02:15 PM",

                  active: true,
                ),

                _timelineItem(

                  title:
                      "Order Placed",

                  subtitle:
                      "Oct 21, 11:30 AM",

                  active: true,

                  isLast: true,
                ),

                const SizedBox(
                  height: 40,
                ),

                /// VIEW DETAILS BUTTON
                ElevatedButton(

                  style:
                      ElevatedButton.styleFrom(

                    minimumSize:
                        const Size(
                      double.infinity,
                      55,
                    ),

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),
                    ),
                  ),

                  onPressed: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>

                            OrderDetailsScreen(
                              order: order,
                            ),
                      ),
                    );
                  },

                  child: const Text(
                    "View Order Details",
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                /// CANCEL ORDER BUTTON
                if (canCancel)
  OutlinedButton(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(double.infinity, 55),
      side: const BorderSide(color: Colors.red),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    onPressed: () async {Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CancelProductScreen(order: order),
  ),
);},
    child: const Text(
      "Cancel Order",
      style: TextStyle(color: Colors.red),
    ),
  ),

if (!canCancel)
  Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status == "Cancelled"
          ? "This order is already cancelled"
          : status == "Completed"
              ? "Completed orders cannot be cancelled"
              : "Cancellation request already submitted",
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
  ),

                const SizedBox(
                  height: 30,
                ),
              ],
            ),
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

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Column(

          children: [

            CircleAvatar(

              radius: 10,

              backgroundColor:

                  active

                      ? Colors.green

                      : Colors.grey
                          .shade300,

              child: const Icon(

                Icons.check,

                size: 12,

                color: Colors.white,
              ),
            ),

            if (!isLast)

              Container(

                width: 2,

                height: 55,

                color:

                    active

                        ? Colors.green

                        : Colors.grey
                            .shade300,
              ),
          ],
        ),

        const SizedBox(width: 15),

        Expanded(

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [

              Text(

                title,

                style:
                    const TextStyle(

                  fontWeight:
                      FontWeight.bold,

                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 4,
              ),

              Text(

                subtitle,

                style:
                    const TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ],
    );
  }
}