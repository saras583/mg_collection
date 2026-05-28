import 'package:flutter/material.dart';

import 'package:mgcollection_app/services/walletservice.dart';

class MGWalletScreen extends StatefulWidget {
  const MGWalletScreen({super.key});

  @override
  State<MGWalletScreen> createState() =>
      _MGWalletScreenState();
}

class _MGWalletScreenState
    extends State<MGWalletScreen> {

  final walletService = WalletService();

  double balance = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWallet();
  }

  Future<void> loadWallet() async {

    final walletBalance =
        await walletService.fetchWalletBalance();

    setState(() {
      balance = walletBalance;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("MG Wallet"),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )

          : Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),

                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.black,
                          Colors.deepPurple,
                        ],
                      ),

                      borderRadius:
                          BorderRadius.circular(20),
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        const Text(
                          "Available Balance",

                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "₹$balance",

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}