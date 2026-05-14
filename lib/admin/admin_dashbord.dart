import 'package:flutter/material.dart';
import 'package:mgcollection_app/admin/widgets/dasboard_card.dart';

import 'widgets/admin_drawer.dart';

class AdminDashboardScreen
    extends StatelessWidget {

  const AdminDashboardScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Dashboard'),
      ),

      drawer: const AdminDrawer(),

      body: Padding(

        padding:
            const EdgeInsets.all(16.0),

        child: GridView.count(

          crossAxisCount: 2,

          crossAxisSpacing: 16,

          mainAxisSpacing: 16,

          childAspectRatio: 2.5,

          children: const [

            DashboardCard(

              title: 'Total Sales',

              value: '\$45,231',

              icon: Icons.attach_money,
            ),

            DashboardCard(

              title: 'Orders',

              value: '1,245',

              icon: Icons.shopping_bag,
            ),

            DashboardCard(

              title: 'Products',

              value: '342',

              icon: Icons.checkroom,
            ),

            DashboardCard(

              title: 'Users',

              value: '8,432',

              icon: Icons.people,
            ),
          ],
        ),
      ),
    );
  }
}