import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/admin/screens/refund_requests_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getOrders() async {
    final user = supabase.auth.currentUser;

    debugPrint('ADMIN USER: ${user?.id}');
    debugPrint('ADMIN EMAIL: ${user?.email}');

    final data = await supabase
        .from('orders')
        .select()
        .order('created_at', ascending: false);

    debugPrint('ADMIN ORDERS DATA: $data');

    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    try {
      await supabase
          .from('orders')
          .update({'status': status})
          .eq('id', orderId);

      if (!mounted) return;

      setState(() {});

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Order marked as $status')));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Color statusColor(String status) {
    if (status == 'Completed') return Colors.green;
    if (status == 'Cancelled') return Colors.red;
    if (status == 'Refund Requested') return Colors.purple;
    if (status == 'Shipped') return Colors.blue;
    return Colors.orange;
  }

  double orderTotal(Map<String, dynamic> order) {
    final total = order['total_price'];

    if (total is int) return total.toDouble();
    if (total is double) return total;
    if (total is String) return double.tryParse(total) ?? 0.0;

    final price = (order['price'] as num?)?.toDouble() ?? 0.0;
    final quantity = (order['quantity'] as num?)?.toInt() ?? 1;

    return price * quantity;
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

  void showStatusSheet(Map<String, dynamic> order) {
    final orderId = order['id'];

    if (orderId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('order id not found')));
      return;
    }

    final statuses = ['Pending', 'Shipped', 'Completed', 'Cancelled'];

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Update Order Status',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...statuses.map((status) {
                return ListTile(
                  title: Text(status),
                  leading: Icon(
                    Icons.circle,
                    color: statusColor(status),
                    size: 14,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    updateOrderStatus(orderId, status);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget orderCard(Map<String, dynamic> order) {
    final status = order['status']?.toString() ?? 'Pending';
    final refundStatus = order['refund_status']?.toString() ?? '';
    final image = order['image']?.toString() ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: orderImage(image),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Qty: ${order['quantity'] ?? 1}'),
                  const SizedBox(height: 4),
                  Text(
                    'Total: ₹${orderTotal(order).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor(status).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor(status),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (refundStatus.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Refund: $refundStatus',
                            style: const TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                showStatusSheet(order);
              },
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Management'),
        actions: [
          IconButton(
            tooltip: 'Refund Requests',
            icon: const Icon(Icons.money_off),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RefundRequestsScreen()),
              ).then((_) {
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return orderCard(orders[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
