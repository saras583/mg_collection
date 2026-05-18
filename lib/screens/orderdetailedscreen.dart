import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {

  final Map<String, dynamic> order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {

    final status =
        order["status"] ?? "Pending";

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F7FA),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Column(

            children: [

              /// TOP IMAGE SECTION
              Stack(

                children: [

                  Container(

                    height: 330,
                    width: double.infinity,

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                          const BorderRadius.only(

                        bottomLeft:
                            Radius.circular(35),

                        bottomRight:
                            Radius.circular(35),
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

                    child: Padding(

                      padding:
                          const EdgeInsets.all(
                        20,
                      ),

                      child: Hero(

                        tag:
                            order["image"],

                        child: Image.asset(

                          order["image"],

                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  /// BACK BUTTON
                  Positioned(

                    top: 20,
                    left: 20,

                    child: CircleAvatar(

                      backgroundColor:
                          Colors.white,

                      child: IconButton(

                        icon: const Icon(
                          Icons.arrow_back,
                        ),

                        onPressed: () {

                          Navigator.pop(
                            context,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              Padding(

                padding:
                    const EdgeInsets.all(20),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    /// PRODUCT NAME
                    Text(

                      order["name"] ?? "",

                      style: const TextStyle(

                        fontSize: 28,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    /// PRICE + STATUS
                    Row(

                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [

                        Text(

                          "₹${order["price"]}",

                          style:
                              const TextStyle(

                            fontSize: 26,

                            color:
                                Colors.green,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        Container(

                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),

                          decoration:
                              BoxDecoration(

                            color:

                                status ==
                                        "Completed"

                                    ? Colors.green
                                        .shade100

                                    : status ==
                                            "Cancelled"

                                        ? Colors.red
                                            .shade100

                                        : Colors.orange
                                            .shade100,

                            borderRadius:
                                BorderRadius.circular(
                              30,
                            ),
                          ),

                          child: Text(

                            status,

                            style:
                                TextStyle(

                              color:

                                  status ==
                                          "Completed"

                                      ? Colors.green

                                      : status ==
                                              "Cancelled"

                                          ? Colors.red

                                          : Colors.orange,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    /// ORDER INFO CARDS
                    Row(

                      children: [

                        Expanded(

                          child: _miniCard(

                            icon:
                                Icons.shopping_bag,

                            title:
                                "Quantity",

                            value:
                                "${order["quantity"] ?? 1}",
                          ),
                        ),

                        const SizedBox(
                          width: 15,
                        ),

                        Expanded(

                          child: _miniCard(

                            icon:
                                Icons.payments,

                            title:
                                "Payment",

                            value:
                                order["payment"] ??
                                    "",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    /// SHIPPING CARD
                    Container(

                      width: double.infinity,

                      padding:
                          const EdgeInsets.all(
                        20,
                      ),

                      decoration: BoxDecoration(

                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          25,
                        ),
                      ),

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          const Row(

                            children: [

                              Icon(
                                Icons.location_on,
                                color:
                                    Colors.red,
                              ),

                              SizedBox(
                                width: 10,
                              ),

                              Text(

                                "Shipping Address",

                                style:
                                    TextStyle(

                                  fontSize:
                                      18,

                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          Text(

                            order["address"] ??
                                "Kinfra, Kerala",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    /// ORDER TIMELINE
                    Container(

                      width: double.infinity,

                      padding:
                          const EdgeInsets.all(
                        20,
                      ),

                      decoration: BoxDecoration(

                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          25,
                        ),
                      ),

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          const Text(

                            "Order Timeline",

                            style: TextStyle(

                              fontSize: 18,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          _timeline(

                            "Order Placed",

                            true,
                          ),

                          _timeline(

                            "Packed",

                            true,
                          ),

                          _timeline(

                            "Shipped",

                            true,
                          ),

                          _timeline(

                            "Delivered",

                            status ==
                                "Completed",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    /// ORDER TIME
                    Container(

                      width: double.infinity,

                      padding:
                          const EdgeInsets.all(
                        18,
                      ),

                      decoration: BoxDecoration(

                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          22,
                        ),
                      ),

                      child: Row(

                        children: [

                          const Icon(
                            Icons.access_time,
                          ),

                          const SizedBox(
                            width: 15,
                          ),

                          Expanded(

                            child: Text(

                              order["time"] ??
                                  "",
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    /// BUTTON
                    SizedBox(

                      width: double.infinity,
                      height: 60,

                      child: ElevatedButton(

                        style:
                            ElevatedButton.styleFrom(

                          backgroundColor:
                              Colors.black,

                          shape:
                              RoundedRectangleBorder(

                            borderRadius:
                                BorderRadius.circular(
                              30,
                            ),
                          ),
                        ),

                        onPressed: () {},

                        child: const Text(

                          "Track Order",

                          style: TextStyle(

                            fontSize: 18,

                            color:
                                Colors.white,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniCard({

    required IconData icon,

    required String title,

    required String value,
  }) {

    return Container(

      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          22,
        ),
      ),

      child: Column(

        children: [

          Icon(icon),

          const SizedBox(
            height: 10,
          ),

          Text(

            title,

            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          Text(

            value,

            style: const TextStyle(

              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeline(
    String title,
    bool active,
  ) {

    return Padding(

      padding:
          const EdgeInsets.only(
        bottom: 18,
      ),

      child: Row(

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

          const SizedBox(
            width: 15,
          ),

          Text(

            title,

            style: TextStyle(

              fontWeight:
                  FontWeight.bold,

              color:

                  active

                      ? Colors.black

                      : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}