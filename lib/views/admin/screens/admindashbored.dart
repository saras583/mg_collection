import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/authu/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final supabase = Supabase.instance.client;

  bool loading = true;

  // Stats
  int totalProducts = 0;
  int totalOrders = 0;
  int totalUsers = 0;
  int totalBanners = 0;
  double totalRevenue = 0;

  // Category counts
  int shirtCount = 0;
  int watchCount = 0;
  int skincareCount = 0;
  int shoesCount = 0;
  int jewelleryCount = 0;
  int pantsCount = 0;

  // Recent products
  List<Map<String, dynamic>> recentProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      // Run all queries in parallel
      final results = await Future.wait([
        supabase.from('products').select(),
        supabase.from('orders').select(),
        supabase.from('users').select('id'),
        supabase.from('banners').select('id').eq('is_active', true),
      ]);

      final products = List<Map<String, dynamic>>.from(results[0]);
      final orders = List<Map<String, dynamic>>.from(results[1]);
      final users = List<Map<String, dynamic>>.from(results[2]);
      final banners = List<Map<String, dynamic>>.from(results[3]);

      // Calculate revenue from orders
      double revenue = 0;
      for (final order in orders) {
        revenue += double.tryParse(order['total']?.toString() ?? '0') ?? 0;
      }

      // Count by category
      int shirts = 0, watches = 0, skincare = 0,
          shoes = 0, jewellery = 0, pants = 0;

      for (final p in products) {
        final cat = (p['category'] ?? '').toString().toLowerCase();
        if (cat == 'shirt') shirts++;
        if (cat == 'watch' || cat == 'watches') watches++;
        if (cat == 'skincare') skincare++;
        if (cat == 'shoes') shoes++;
        if (cat == 'jewellery') jewellery++;
        if (cat == 'pants') pants++;
      }

      // Recent 5 products
      final recent = [...products];
      recent.sort((a, b) => (b['id'] ?? 0).compareTo(a['id'] ?? 0));

      setState(() {
        totalProducts = products.length;
        totalOrders = orders.length;
        totalUsers = users.length;
        totalBanners = banners.length;
        totalRevenue = revenue;

        shirtCount = shirts;
        watchCount = watches;
        skincareCount = skincare;
        shoesCount = shoes;
        jewelleryCount = jewellery;
        pantsCount = pants;

        recentProducts = recent.take(5).toList();
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      print('Dashboard fetch error: $e');
    }
  }

  Future<void> logout(BuildContext context) async {
    await supabase.auth.signOut();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () => _fetchDashboardData(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── OVERVIEW STATS ──
                    const Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.4,
                      children: [
                        _statCard(
                          title: 'Products',
                          count: '$totalProducts',
                          icon: Icons.shopping_bag,
                          color: Colors.blue,
                        ),
                        _statCard(
                          title: 'Revenue',
                          count: '₹${totalRevenue.toInt()}',
                          icon: Icons.currency_rupee,
                          color: Colors.green,
                        ),
                        _statCard(
                          title: 'Orders',
                          count: '$totalOrders',
                          icon: Icons.receipt_long,
                          color: Colors.orange,
                        ),
                        _statCard(
                          title: 'Users',
                          count: '$totalUsers',
                          icon: Icons.people,
                          color: Colors.purple,
                        ),
                        _statCard(
                          title: 'Active Banners',
                          count: '$totalBanners',
                          icon: Icons.photo_library_outlined,
                          color: Colors.pink,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ── CATEGORY BREAKDOWN ──
                    const Text(
                      'Category Breakdown',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.1,
                      children: [
                        _categoryCard('Shirts', shirtCount,
                            Icons.checkroom, Colors.red),
                        _categoryCard('Watches', watchCount,
                            Icons.watch, Colors.purple),
                        _categoryCard('Skincare', skincareCount,
                            Icons.spa, Colors.teal),
                        _categoryCard('Shoes', shoesCount,
                            Icons.garage, Colors.orange),
                        _categoryCard('Jewellery', jewelleryCount,
                            Icons.diamond, Colors.pink),
                        _categoryCard('Pants', pantsCount,
                            Icons.shopping_bag, Colors.indigo),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ── RECENT PRODUCTS ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Products',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Last 5 added',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    recentProducts.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(30),
                              child: Text('No products added yet'),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: recentProducts.length,
                            itemBuilder: (context, index) {
                              final product = recentProducts[index];
                              final imageUrl =
                                  product['image']?.toString() ?? '';

                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(10),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: imageUrl.isNotEmpty
                                        ? Image.network(
                                            imageUrl,
                                            width: 52,
                                            height: 52,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const CircleAvatar(
                                              child: Icon(Icons.image),
                                            ),
                                          )
                                        : const CircleAvatar(
                                            child: Icon(Icons.image),
                                          ),
                                  ),
                                  title: Text(
                                    product['name'] ?? 'Unknown',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text('₹${product['price'] ?? 0}'),
                                      const SizedBox(width: 8),
                                      // Stock indicator
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: (product['stock'] ?? 0) > 0
                                              ? Colors.green.shade50
                                              : Colors.red.shade50,
                                          borderRadius:
                                              BorderRadius.circular(999),
                                        ),
                                        child: Text(
                                          'Stock: ${product['stock'] ?? 0}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: (product['stock'] ?? 0) > 0
                                                ? Colors.green.shade700
                                                : Colors.red.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      product['category'] ?? 'Unknown',
                                      style: TextStyle(
                                        color: Colors.blue.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _statCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(
    String title,
    int count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 6),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}