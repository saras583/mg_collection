import 'package:flutter/material.dart';
import '../widgets/admin_drawer.dart';
import 'order_details.dart';

class ManageOrdersScreen extends StatelessWidget {
  const ManageOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Orders')),
      drawer: const AdminDrawer(),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Order #001'),
            subtitle: const Text('John Doe - $250.00'),
            trailing: const Text('Delivered', style: TextStyle(color: Colors.green)),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderDetailsScreen()));
            },
          ),
          ListTile(
            title: const Text('Order #002'),
            subtitle: const Text('Mike Smith - $180.00'),
            trailing: const Text('Processing', style: TextStyle(color: Colors.orange)),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderDetailsScreen()));
            },
          ),
        ],
      ),
    );
  }
}
