import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Checkoutpage extends StatefulWidget {
  final Map<String, dynamic> product;

  const Checkoutpage({
    super.key,
    required this.product,
  });

  @override
  State<Checkoutpage> createState() => _CheckoutpageState();
}

class _CheckoutpageState extends State<Checkoutpage> {
  String selectedPayment = "Cash on Delivery";
  bool placingOrder = false;

  double get price {
    final value = widget.product['price'];

    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;

    return 0.0;
  }

  int get quantity {
    final value = widget.product['quantity'];

    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 1;

    return 1;
  }

  String get productName {
    return widget.product['name']?.toString() ?? 'Product';
  }

  String get productImage {
    return widget.product['image']?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final double subtotal = price * quantity;
    const double shipping = 40;
    final double totalPrice = subtotal + shipping;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey.shade200,
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 44),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Contact Information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Edit"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    infoRow(
                      icon: Icons.email_outlined,
                      title: "mail@gmail.com",
                      subtitle: "Email",
                    ),
                    const SizedBox(height: 15),
                    infoRow(
                      icon: Icons.phone_outlined,
                      title: "+91 9876543210",
                      subtitle: "Phone",
                    ),
                    const SizedBox(height: 15),
                    infoRow(
                      icon: Icons.location_on_outlined,
                      title: "Kinfra, Calicut",
                      subtitle: "Address",
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/locationimage.png',
                        fit: BoxFit.cover,
                        height: 160,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 160,
                            width: double.infinity,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.location_on),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Payment Method",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        showPaymentOptions(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.payment),
                                const SizedBox(width: 10),
                                Text(selectedPayment),
                              ],
                            ),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Order Summary",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              productImage,
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 90,
                                  width: 90,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Quantity: $quantity",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "₹${price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
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

                    priceRow(
                      "Subtotal",
                      "₹${subtotal.toStringAsFixed(2)}",
                    ),
                    const SizedBox(height: 12),
                    priceRow(
                      "Shipping",
                      "₹${shipping.toStringAsFixed(2)}",
                    ),
                    const SizedBox(height: 12),
                    priceRow(
                      "Delivery",
                      "Tomorrow",
                    ),

                    const Divider(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Cost",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "₹${totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.discount),
                              SizedBox(width: 10),
                              Text("Apply Coupon"),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text("Apply"),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: placingOrder
                            ? null
                            : () {
                                placeOrder(selectedPayment);
                              },
                        child: placingOrder
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text("Pay with $selectedPayment"),
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

  BoxDecoration _cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  void showPaymentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Payment Method",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              paymentTile(
                icon: Icons.money,
                title: "Cash on Delivery",
              ),
              paymentTile(
                icon: Icons.account_balance_wallet,
                title: "MGCollection Wallet",
              ),
              paymentTile(
                icon: Icons.payment,
                title: "UPI / Google Pay",
              ),
              paymentTile(
                icon: Icons.credit_card,
                title: "Card Payment",
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
      trailing: selectedPayment == title
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

  Future<void> placeOrder(String method) async {
    setState(() {
      placingOrder = true;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      await Supabase.instance.client.from('orders').insert({
        "user_id": user.id,
        "product_id": widget.product['id'],
        "product_name": productName,
        "price": price,
        "quantity": quantity,
        "payment_method": method,
        "status": "Pending",
        "image": productImage,
        "total_price": price * quantity + 40,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        placingOrder = false;
      });
    }
  }
}

Widget priceRow(String title, String price) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget infoRow({
  required IconData icon,
  required String title,
  required String subtitle,
}) {
  return Row(
    children: [
      CircleAvatar(
        radius: 22,
        backgroundColor: Colors.grey.shade200,
        child: Icon(
          icon,
          color: Colors.black,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
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
      ),
    ],
  );
}