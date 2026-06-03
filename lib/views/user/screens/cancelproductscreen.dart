import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CancelProductScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const CancelProductScreen({
    super.key,
    required this.order,
  });

  @override
  State<CancelProductScreen> createState() => _CancelProductScreenState();
}

class _CancelProductScreenState extends State<CancelProductScreen> {
  final supabase = Supabase.instance.client;

  String refundMethod = 'MG Wallet';
  bool loading = false;

  final accountNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscController = TextEditingController();

  double get refundAmount {
    final value = widget.order['total_price'] ?? widget.order['price'];

    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;

    return 0.0;
  }

  @override
  void dispose() {
    accountNameController.dispose();
    accountNumberController.dispose();
    ifscController.dispose();
    super.dispose();
  }

Future<void> cancelOrder() async {
  final user = supabase.auth.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please login first')),
    );
    return;
  }

  setState(() {
    loading = true;
  });

  try {
    final orderId = widget.order['id'];

    await supabase.from('orders').update({
      'status': 'Refund Requested',
      'refund_method': refundMethod,
      'refund_amount': refundAmount,
      'refund_status': 'Pending',
      'bank_account_name': refundMethod == 'Bank Account'
          ? accountNameController.text.trim()
          : null,
      'bank_account_number': refundMethod == 'Bank Account'
          ? accountNumberController.text.trim()
          : null,
      'bank_ifsc': refundMethod == 'Bank Account'
          ? ifscController.text.trim()
          : null,
    }).eq('id', orderId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refund request submitted')),
    );

    Navigator.pop(context);
    Navigator.pop(context);
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  } finally {
    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }
}   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancel Order'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Refund Amount',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '₹${refundAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Select Refund Method',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            RadioListTile<String>(
              value: 'MG Wallet',
              groupValue: refundMethod,
              title: const Text('MG Wallet'),
              subtitle: const Text('Refund amount will be added instantly'),
              onChanged: (value) {
                setState(() {
                  refundMethod = value!;
                });
              },
            ),
            RadioListTile<String>(
              value: 'Bank Account',
              groupValue: refundMethod,
              title: const Text('Bank Account'),
              subtitle: const Text('Refund request will be submitted'),
              onChanged: (value) {
                setState(() {
                  refundMethod = value!;
                });
              },
            ),
            if (refundMethod == 'Bank Account') ...[
              const SizedBox(height: 15),
              TextField(
                controller: accountNameController,
                decoration: const InputDecoration(
                  labelText: 'Account Holder Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: accountNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ifscController,
                decoration: const InputDecoration(
                  labelText: 'IFSC Code',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: loading ? null : cancelOrder,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Confirm Cancellation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}