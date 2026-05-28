import 'package:flutter/material.dart';
import 'package:mgcollection_app/services/walletservice.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderSettingsScreen extends StatefulWidget {

  final String orderId;
  final double refundAmount;

  const OrderSettingsScreen({
    super.key,
    required this.orderId,
    required this.refundAmount,
  });

  @override
  State<OrderSettingsScreen> createState() =>
      _OrderSettingsScreenState();
}

class _OrderSettingsScreenState
    extends State<OrderSettingsScreen> {

  final walletService = WalletService();

  bool isLoading = false;

  /// CANCEL ORDER + REFUND TO WALLET
  Future<void> refundToWallet() async {

    setState(() {
      isLoading = true;
    });

    try {

      // ADD MONEY TO WALLET
      await walletService.addMoney(
        widget.refundAmount,
      );

      // UPDATE ORDER STATUS
      await Supabase.instance.client
          .from('orders')
          .update({
            "status": "cancelled",
          })
          .eq('id', widget.orderId);

      if (mounted) {

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "₹${widget.refundAmount} refunded to MG Wallet",
            ),
          ),
        );
      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Refund failed: $e",
          ),
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  /// BANK REFUND
  Future<void> refundToBank() async {

    setState(() {
      isLoading = true;
    });

    try {

      // UPDATE ORDER STATUS
      await Supabase.instance.client
          .from('orders')
          .update({
            "status": "cancelled",
          })
          .eq('id', widget.orderId);

      if (mounted) {

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Refund will arrive in 2-5 working days",
            ),
          ),
        );
      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Refund failed: $e",
          ),
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  /// DIALOG
  void showCancelOrderDialog() {

    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            "Cancel Order",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text(
                "Refund Amount: ₹${widget.refundAmount}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "Choose where you want the refund.",
              ),

              const SizedBox(height: 20),

              /// WALLET REFUND
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,

                  child: Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                  ),
                ),

                title: const Text("MG Wallet"),

                subtitle: const Text(
                  "Instant refund",
                ),

                onTap: refundToWallet,
              ),

              const Divider(),

              /// BANK REFUND
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,

                  child: Icon(
                    Icons.account_balance,
                    color: Colors.white,
                  ),
                ),

                title: const Text("Bank Account"),

                subtitle: const Text(
                  "2-5 working days",
                ),

                onTap: refundToBank,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Order Settings"),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )

          : Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [

                  ListTile(
                    leading: const Icon(
                      Icons.shopping_bag,
                    ),

                    title: const Text(
                      "My Orders",
                    ),

                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                    ),

                    onTap: () {},
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),

                    title: const Text(
                      "Cancel Product Order",

                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: const Text(
                      "Cancel your placed order",
                    ),

                    onTap: showCancelOrderDialog,
                  ),
                ],
              ),
            ),
    );
  }
}