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

  bool placingOrder = false;

  @override
  Widget build(BuildContext context) {

    double subtotal =
        (widget.product['price'] *
            (widget.product['quantity'] ?? 1));

    double shipping = 40;

    double totalPrice =
        subtotal + shipping;

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
                    const EdgeInsets.all(16),

                child: Row(

                  children: [

                    GestureDetector(

                      onTap: () {
                        Navigator.pop(context);
                      },

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

                    const Expanded(

                      child: Center(

                        child: Text(

                          'Checkout',

                          style: TextStyle(

                            fontSize: 20,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 44),
                  ],
                ),
              ),

              /// CONTACT INFO CARD
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

                  boxShadow: [

                    BoxShadow(

                      color: Colors.black
                          .withOpacity(0.05),

                      blurRadius: 10,

                      offset: const Offset(
                        0,
                        4,
                      ),
                    ),
                  ],
                ),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    /// TITLE
                    Row(

                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [

                        const Text(

                          'Contact Information',

                          style: TextStyle(

                            fontWeight:
                                FontWeight.bold,

                            fontSize: 18,
                          ),
                        ),

                        TextButton(

                          onPressed: () {},

                          child: const Text(
                            "Edit",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    /// EMAIL
                    WidgetInfoRow(

                      icon:
                          Icons.email_outlined,

                      title:
                          "mail@gmail.com",

                      subtitle: "Email",
                    ),

                    const SizedBox(height: 15),

                    /// PHONE
                    WidgetInfoRow(

                      icon:
                          Icons.phone_outlined,

                      title:
                          "+91 9876543210",

                      subtitle: "Phone",
                    ),

                    const SizedBox(height: 15),

                    /// ADDRESS
                    WidgetInfoRow(

                      icon:
                          Icons.location_on_outlined,

                      title:
                          "Kinfra, Calicut",

                      subtitle: "Address",
                    ),

                    const SizedBox(height: 20),

                    /// MAP IMAGE
                    ClipRRect(

                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),

                      child: Image.asset(
                        'assets/images/locationimage.png',

                        fit: BoxFit.cover,

                        height: 160,

                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),

              /// PAYMENT METHOD
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

                  boxShadow: [

                    BoxShadow(

                      color: Colors.black
                          .withOpacity(0.05),

                      blurRadius: 10,

                      offset: const Offset(
                        0,
                        4,
                      ),
                    ),
                  ],
                ),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Text(

                      "Payment Method",

                      style: TextStyle(

                        fontWeight:
                            FontWeight.bold,

                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 15),

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
                              Colors.grey.shade100,

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

              /// ORDER SUMMARY
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

                  boxShadow: [

                    BoxShadow(

                      color: Colors.black
                          .withOpacity(0.05),

                      blurRadius: 10,

                      offset: const Offset(
                        0,
                        4,
                      ),
                    ),
                  ],
                ),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Text(

                      "Order Summary",

                      style: TextStyle(

                        fontWeight:
                            FontWeight.bold,

                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// PRODUCT CARD
                    Container(

                      padding:
                          const EdgeInsets.all(
                        12,
                      ),

                      decoration: BoxDecoration(

                        color:
                            Colors.grey.shade100,

                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),

                      child: Row(

                        children: [

                          /// IMAGE
                          ClipRRect(

                            borderRadius:
                                BorderRadius.circular(
                              12,
                            ),

                            child: Image.network(

                              widget.product[
                                  'image'],

                              height: 90,

                              width: 90,

                              fit: BoxFit.cover,

                              errorBuilder: (
                                context,
                                error,
                                stackTrace,
                              ) {

                                return Container(

                                  height: 90,

                                  width: 90,

                                  color: Colors
                                      .grey.shade300,

                                  child: const Icon(
                                    Icons
                                        .image_not_supported,
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// DETAILS
                          Expanded(

                            child: Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(

                                  widget.product[
                                      'name'],

                                  style:
                                      const TextStyle(

                                    fontWeight:
                                        FontWeight
                                            .bold,

                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(
                                  height: 8,
                                ),

                                Text(

                                  "Quantity: ${widget.product['quantity']}",

                                  style:
                                      TextStyle(
                                    color: Colors
                                        .grey.shade600,
                                  ),
                                ),

                                const SizedBox(
                                  height: 8,
                                ),

                                Text(

                                  "₹${widget.product['price']}",

                                  style:
                                      const TextStyle(

                                    fontWeight:
                                        FontWeight
                                            .bold,

                                    color:
                                        Colors.green,

                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// PRICE DETAILS
                    _priceRow(
                      "Subtotal",
                      "₹${subtotal.toStringAsFixed(2)}",
                    ),

                    const SizedBox(height: 12),

                    _priceRow(
                      "Shipping",
                      "₹40",
                    ),

                    const SizedBox(height: 12),

                    _priceRow(
                      "Delivery",
                      "Tomorrow",
                    ),

                    const Divider(
                      height: 30,
                    ),

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

                            fontSize: 18,
                          ),
                        ),

                        Text(

                          "₹${totalPrice.toStringAsFixed(2)}",

                          style: const TextStyle(

                            fontWeight:
                                FontWeight.bold,

                            fontSize: 22,

                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// COUPON
                    Container(

                      padding:
                          const EdgeInsets.all(
                        15,
                      ),

                      decoration: BoxDecoration(

                        color:
                            Colors.grey.shade100,

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

                          const Row(

                            children: [

                              Icon(
                                Icons.discount,
                              ),

                              SizedBox(width: 10),

                              Text(
                                "Apply Coupon",
                              ),
                            ],
                          ),

                          TextButton(

                            onPressed: () {},

                            child: const Text(
                              "Apply",
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// PLACE ORDER BUTTON
                    SizedBox(

                      width: double.infinity,

                      height: 55,

                      child: ElevatedButton(

                        style:
                            ElevatedButton.styleFrom(

                          shape:
                              RoundedRectangleBorder(

                            borderRadius:
                                BorderRadius.circular(
                              30,
                            ),
                          ),
                        ),

                        onPressed:
                            placingOrder
                                ? null
                                : () {

                                    placeOrder(
                                      context,
                                      selectedPayment,
                                    );
                                  },

                        child:
                            placingOrder

                                ? const CircularProgressIndicator(
                                    color:
                                        Colors.white,
                                  )

                                : Text(
                                    "Pay with $selectedPayment",
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

                  fontSize: 20,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              paymentTile(
                icon: Icons.money,
                title:
                    "Cash on Delivery",
              ),

              paymentTile(
                icon: Icons
                    .account_balance_wallet,
                title:
                    "MGCollection Wallet",
              ),

              paymentTile(
                icon: Icons.payment,
                title:
                    "UPI / Google Pay",
              ),

              paymentTile(
                icon: Icons.credit_card,
                title:
                    "Card Payment",
              ),
            ],
          ),
        );
      },
    );
  }

  Widget paymentTile({

    required IconData icon,

    required String title,
  }) {

    return ListTile(

      leading: Icon(icon),

      title: Text(title),

      trailing:
          selectedPayment == title
              ? const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )
              : null,

      onTap: () {

        setState(() {
          selectedPayment = title;
        });

        Navigator.pop(context);
      },
    );
  }

  /// PLACE ORDER
  Future<void> placeOrder(
    BuildContext context,
    String method,
  ) async {

    setState(() {
      placingOrder = true;
    });

    await Future.delayed(
      const Duration(seconds: 2),
    );

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

    setState(() {
      placingOrder = false;
    });

    showDialog(

      context: context,

      builder: (_) {

        return AlertDialog(

          shape:
              RoundedRectangleBorder(

            borderRadius:
                BorderRadius.circular(
              20,
            ),
          ),

          title: const Text(
            "Order Successful",
          ),

          content: const Text(
            "Your order has been placed successfully.",
          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(context);
                Navigator.pop(context);
              },

              child: const Text("OK"),
            ),
          ],
        );
      },
    );
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

        style: TextStyle(
          color: Colors.grey.shade600,
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

        radius: 22,

        backgroundColor:
            Colors.grey.shade200,

        child: Icon(
          icon,
          color: Colors.black,
        ),
      ),

      const SizedBox(width: 12),

      Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(

            title,

            style: const TextStyle(

              fontWeight:
                  FontWeight.bold,

              fontSize: 15,
            ),
          ),

          const SizedBox(height: 2),

          Text(

            subtitle,

            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    ],
  );
}