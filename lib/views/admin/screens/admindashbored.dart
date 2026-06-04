import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mgcollection_app/views/authu/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final productBox = Hive.box('products');
    final orderBox = Hive.box('orders');

    final products = productBox.values.toList();

    int shirtCount = 0;
    int watchCount = 0;
    int skincareCount = 0;
    int shoesCount = 0;
    int jewelleryCount = 0;

    double totalRevenue = 0;

    for (final order in orderBox.values) {
      totalRevenue += double.tryParse(order['price'].toString()) ?? 0;
    }

    for (final product in products) {
      final category = product['category'];

      if (category == 'Shirt') shirtCount++;
      if (category == 'Watch') watchCount++;
      if (category == 'Skincare') skincareCount++;
      if (category == 'Shoes') shoesCount++;
      if (category == 'Jewellery') jewelleryCount++;
    }

    final recentProducts = products.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Analytics',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  dashboardCard(
                    title: 'Products',
                    count: products.length.toString(),
                    icon: Icons.shopping_bag,
                    color: Colors.blue,
                  ),
                  dashboardCard(
                    title: 'Revenue',
                    count: '₹${totalRevenue.toInt()}',
                    icon: Icons.currency_rupee,
                    color: Colors.green,
                  ),
                  dashboardCard(
                    title: 'Shoes',
                    count: shoesCount.toString(),
                    icon: Icons.checkroom,
                    color: Colors.orange,
                  ),
                  dashboardCard(
                    title: 'Watches',
                    count: watchCount.toString(),
                    icon: Icons.watch,
                    color: Colors.purple,
                  ),
                  dashboardCard(
                    title: 'Shirts',
                    count: shirtCount.toString(),
                    icon: Icons.shopping_bag,
                    color: Colors.red,
                  ),
                  dashboardCard(
                    title: 'Skincare',
                    count: skincareCount.toString(),
                    icon: Icons.spa,
                    color: Colors.teal,
                  ),
                  dashboardCard(
                    title: 'Jewellery',
                    count: jewelleryCount.toString(),
                    icon: Icons.diamond,
                    color: Colors.pink,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                'Recent Products',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              recentProducts.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Text('No Products Added'),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentProducts.length,
                      itemBuilder: (context, index) {
                        final product = recentProducts[index];
                        final imagePath = product['image']?.toString();

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: imagePath != null && imagePath.isNotEmpty
                                ? CircleAvatar(
                                    radius: 28,
                                    backgroundImage: FileImage(File(imagePath)),
                                  )
                                : const CircleAvatar(
                                    radius: 28,
                                    child: Icon(Icons.image),
                                  ),
                            title: Text(
                              product['name'] ?? 'Unknown Product',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text('₹${product['price'] ?? '0'}'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                product['category'] ?? 'Unknown',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dashboardCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(
            count,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}