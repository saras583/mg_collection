import 'package:flutter/material.dart';
import '../widgets/admin_drawer.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users')),
      drawer: const AdminDrawer(),
      body: ListView(
        children: const [
          ListTile(leading: CircleAvatar(child: Icon(Icons.person)), title: Text('John Doe'), subtitle: Text('john@example.com')),
          ListTile(leading: CircleAvatar(child: Icon(Icons.person)), title: Text('Mike Smith'), subtitle: Text('mike@example.com')),
        ],
      ),
    );
  }
}
