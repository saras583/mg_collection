import 'package:flutter/material.dart';
import 'package:mgcollection_app/admin/Analytics/analyitical_screen.dart';
import 'package:mgcollection_app/admin/admin_dashbord.dart';
import 'package:mgcollection_app/admin/user/manage_user.dart';
import '../admin_dashboard.dart';
import '../products/manage_products.dart';
import '../orders/manage_orders.dart';
import '../users/manage_users.dart';
import '../analytics/analytics_screen.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF1E1E2C)),
            child: Text('Mg Cilllection\nAdmin', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.checkroom),
            title: const Text('Products'),
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ManageProductsScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Orders'),
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ManageProductsScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Users'),
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ManageUsersScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Analytics'),
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AnalyticsScreen())),
          ),
        ],
      ),
    );
  }
}
