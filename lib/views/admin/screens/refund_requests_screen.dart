import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RefundRequestsScreen extends StatefulWidget {
  const RefundRequestsScreen({super.key});

  @override
  State<RefundRequestsScreen> createState() => _RefundRequestsScreenState();
}

class _RefundRequestsScreenState extends State<RefundRequestsScreen> {
  final supabase = Supabase.instance.client;

Future<List<Map<String, dynamic>>> getRefundRequests() async {
  try {
    final data = await supabase
        .from('orders')
        .select();

    print('ALL ORDERS => $data');

    final refunds = data.where((order) {
      return order['refund_status'] == 'Pending';
    }).toList();

    print('REFUND ORDERS => $refunds');

    return List<Map<String, dynamic>>.from(refunds);
  } catch (e) {
    print('REFUND ERROR => $e');
    return [];
  }
}  double getRefundAmount(Map<String, dynamic> order) {
    final totalPrice = order['total_price'];

    if (totalPrice is int) return totalPrice.toDouble();
    if (totalPrice is double) return totalPrice;
    if (totalPrice is String) return double.tryParse(totalPrice) ?? 0.0;

    final price = (order['price'] as num?)?.toDouble() ?? 0.0;
    final quantity = (order['quantity'] as num?)?.toInt() ?? 1;

    return price * quantity;
  }

Future<void> approveRefund(Map<String, dynamic> order) async {
  try {
    final userId = order['user_id'];
    final refundAmount = getRefundAmount(order);

    final wallet = await supabase
        .from('wallets')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (wallet == null) {
      await supabase.from('wallets').insert({
        'user_id': userId,
        'balance': refundAmount,
      });
    } else {
      final currentBalance =
          (wallet['balance'] as num?)?.toDouble() ?? 0.0;

      await supabase.from('wallets').update({
        'balance': currentBalance + refundAmount,
      }).eq('user_id', userId);
    }

    await supabase.from('wallet_transactions').insert({
      'user_id': userId,
      'amount': refundAmount,
      'type': 'refund',
      'title': 'Order Refund',
      'description': 'Refund for ${order['product_name']}',
    });

    await supabase.from('refunds').insert({
      'order_id': order['id'],
      'user_id': userId,
      'amount': refundAmount,
      'refund_method': 'MG Wallet',
      'status': 'Approved',
    });

    await supabase.from('orders').update({
      'status': 'Cancelled',
      'refund_status': 'Refunded',
      'refund_amount': refundAmount,
    }).eq('id', order['id']);

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refund approved successfully'),
      ),
    );
  } catch (e) {
    print('APPROVE REFUND ERROR => $e');

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}
  Future<void> rejectRefund(Map<String, dynamic> order) async {
    try {
      await supabase.from('orders').update({
        'status': 'Pending',
        'refund_status': 'Rejected',
      }).eq('id', order['id']);

      await supabase.from('refunds').insert({
        'order_id': order['id'],
        'user_id': order['user_id'],
        'amount': getRefundAmount(order),
        'refund_method': order['refund_method'] ?? 'MG Wallet',
        'status': 'Rejected',
      });

      if (!mounted) return;

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Refund rejected')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Widget orderImage(String image) {
    return Image.network(
      image,
      width: 70,
      height: 70,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 70,
          height: 70,
          color: Colors.grey.shade300,
          child: const Icon(Icons.image_not_supported),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refund Requests'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getRefundRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final requests = snapshot.data ?? [];

          if (requests.isEmpty) {
            return const Center(
              child: Text('No Refund Requests'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final order = requests[index];
              final refundAmount = getRefundAmount(order);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: orderImage(order['image']?.toString() ?? ''),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order['product_name']?.toString() ?? 'No Product',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text('Refund: ₹${refundAmount.toStringAsFixed(2)}'),
                            const SizedBox(height: 6),
                            Text(
                              'Method: ${order['refund_method'] ?? 'MG Wallet'}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      approveRefund(order);
                                    },
                                    child: const Text('Approve'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      rejectRefund(order);
                                    },
                                    child: const Text('Reject'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}