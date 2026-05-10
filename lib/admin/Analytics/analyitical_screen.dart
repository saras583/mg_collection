import 'package:flutter/material.dart';
import '../widgets/admin_drawer.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      drawer: const AdminDrawer(),
      body: const Center(
        child: Text('Analytics charts would go here.'),
      ),
    );
  }
}
