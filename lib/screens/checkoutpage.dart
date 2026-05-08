import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Checkoutpage extends StatefulWidget {

  final Map<String, dynamic> product;

  const Checkoutpage({
    super.key,
    required this.product,
  });

  @override
  State<Checkoutpage> createState() =>
      _CheckoutpageState();
}

class _CheckoutpageState
    extends State<Checkoutpage> {

  String selectedPayment =
      "Cash on Delivery";

  @override
  Widget build(BuildContext context) {

    int totalPrice =
        (widget.product['price'] *
                widget.product['quantity']) +
            40;

    return Scaffold(

      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

      body: SafeArea(

        child: SingleChildScrollView(

          child: Column(

            children: [

              /// APPBAR
              Padding(

                padding:
                    const EdgeInsets.all(8.0),

                child: Stack(

                  alignment: Alignment.center,

                  children: [

                    Align(

                      alignment:
                          Alignment.centerLeft,

                      child: GestureDetector(

                        onTap: () =>
                            Navigator.pop(context),

                        child: CircleAvatar(

                          radius: 22,

                          backgroundColor:
                              Colors.grey.shade200,

                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    const Text(

                      'Checkout',

                      style: TextStyle(

                        fontSize: 18,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// CONTACT INFO
              Container(

                margin:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),

                padding:
                    const EdgeInsets.all(16),

                decoration: BoxDecoration(

                  color:
                      Theme.of(context)
                          .cardColor,

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Text(

                      'Contact Information',

                      style: TextStyle(

                        fontWeight:
                            FontWeight.bold,

                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 10),

                    WidgetInfoRow(

                      icon:
                          Icons.email_outlined,

                      title:
                          "mail@gmail.com",

                      subtitle: "Email",
                    ),

                    const SizedBox(height: 10),

                    WidgetInfoRow(

                      icon:
                          Icons.phone_outlined,

                      title:
                          "+88-692-764-269",

                      subtitle: "Phone",
                    ),

                    const SizedBox(height: 10),

                    WidgetInfoRow(

                      icon:
                          Icons.location_on_outlined,

                      title: "Kinfra",

                      subtitle: "Address",
                    ),

                    const SizedBox(height: 15),

                    ClipRRect(

                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),

                      child: Image.asset(
                        'assets/images/locationimage.png',
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// PAYMENT METHOD
                    const Text(

                      "Payment Method",

                      style: TextStyle(

                        fontWeight:
                            FontWeight.bold,

                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(

                      onTap: () {
                        showPaymentOptions(
                          context,
                        );
                      },

                      child: Container(

                        padding:
                            const EdgeInsets.all(
                          15,
                        ),

                        decoration: BoxDecoration(

                          color:
                              Colors.grey.shade200,

                          borderRadius:
                              BorderRadius.circular(
                            15,
                          ),
                        ),

                        child: Row(

                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                          children: [

                            Row(

                              children: [

                                const Icon(
                                  Icons.payment,
                                ),

                                const SizedBox(
                                  width: 10,
                                ),

                                Text(
                                  selectedPayment,
                                ),
                              ],
                            ),

                            const Icon(
                              Icons
                                  .keyboard_arrow_down,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// PRICE DETAILS
              Container(

                margin:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),

                padding:
                    const EdgeInsets.all(16),

                decoration: BoxDecoration(

                  color:
                      Theme.of(context)
                          .cardColor,

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    /// SUBTOTAL
                    _priceRow(

                      "Subtotal",

                      "₹${widget.product['price'] * widget.product['quantity']}",
                    ),

                    const SizedBox(height: 10),

                    /// SHIPPING
                    _priceRow(
                      "Shipping",
                      "₹40",
                    ),

                    const Divider(
                      height: 20,
                      thickness: 1,
                    ),

                    /// PRODUCT
                    Row(

                      children: [

                        Image.asset(

                          widget.product['image'],

                          height: 60,

                          width: 60,
                        ),

                        const SizedBox(width: 10),

                        Expanded(

                          child: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Text(
                                widget.product['name'],
                              ),

                              Text(
                                "Qty: ${widget.product['quantity']}",
                              ),
                            ],
                          ),
                        ),

                        Text(

                          "₹${widget.product['price']}",

                          style: const TextStyle(

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// TOTAL
                    Row(

                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [

                        const Text(

                          "Total Cost",

                          style: TextStyle(

                            fontWeight:
                                FontWeight.bold,

                            fontSize: 16,
                          ),
                        ),

                        Text(

                          "₹$totalPrice",

                          style: const TextStyle(

                            fontWeight:
                                FontWeight.bold,

                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// PAYMENT BUTTON
                    GestureDetector(

                      onTap: () {

                        placeOrder(
                          context,
                          selectedPayment,
                        );
                      },

                      child: Container(

                        width: double.infinity,

                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 15,
                        ),

                        decoration: BoxDecoration(

                          color: Colors.blue,

                          borderRadius:
                              BorderRadius.circular(
                            30,
                          ),
                        ),

                        child: Center(

                          child: Text(

                            "Pay with $selectedPayment",

                            style: TextStyle(

                              color:
                                  Theme.of(context)
                                      .cardColor,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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

  /// PAYMENT OPTIONS
  void showPaymentOptions(
    BuildContext context,
  ) {

    showModalBottomSheet(

      context: context,

      shape:
          const RoundedRectangleBorder(

        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),

      builder: (_) {

        return Padding(

          padding:
              const EdgeInsets.all(20),

          child: Column(

            mainAxisSize:
                MainAxisSize.min,

            children: [

              const Text(

                "Select Payment Method",

                style: TextStyle(

                  fontSize: 18,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              ListTile(

                leading:
                    const Icon(Icons.money),

                title: const Text(
                  "Cash on Delivery",
                ),

                onTap: () {

                  setState(() {

                    selectedPayment =
                        "Cash on Delivery";
                  });

                  Navigator.pop(context);
                },
              ),

              ListTile(

                leading: const Icon(
                  Icons
                      .account_balance_wallet,
                ),

                title: const Text(
                  "UPI / Google Pay",
                ),

                onTap: () {

                  setState(() {

                    selectedPayment =
                        "UPI / Google Pay";
                  });

                  Navigator.pop(context);
                },
              ),

              ListTile(

                leading: const Icon(
                  Icons.credit_card,
                ),

                title: const Text(
                  "Card Payment",
                ),

                onTap: () {

                  setState(() {

                    selectedPayment =
                        "Card Payment";
                  });

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// PLACE ORDER
  void placeOrder(
    BuildContext context,
    String method,
  ) {

    var orderBox =
        Hive.box('orders');

    orderBox.add({

      "name":
          widget.product['name'],

      "price":
          widget.product['price'],

      "image":
          widget.product['image'],

      "quantity":
          widget.product['quantity'],

      "payment":
          method,

      "time":
          DateTime.now().toString(),
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        content: Text(
          "Order placed using $method",
        ),
      ),
    );

    Navigator.pop(context);
  }
}

/// PRICE ROW
Widget _priceRow(
  String title,
  String price,
) {

  return Row(

    mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

    children: [

      Text(

        title,

        style: const TextStyle(
          color: Colors.grey,
        ),
      ),

      Text(

        price,

        style: const TextStyle(

          fontWeight:
              FontWeight.bold,
        ),
      ),
    ],
  );
}

/// INFO ROW
Widget WidgetInfoRow({

  required IconData icon,

  required String title,

  required String subtitle,
}) {

  return Row(

    children: [

      CircleAvatar(

        radius: 20,

        backgroundColor:
            Colors.grey.shade200,

        child: Icon(
          icon,
          color: Colors.black,
        ),
      ),

      const SizedBox(width: 10),

      Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(

            title,

            style: const TextStyle(

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          Text(

            subtitle,

            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ],
  );
}