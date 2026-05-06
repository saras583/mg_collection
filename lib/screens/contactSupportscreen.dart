import 'package:flutter/material.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Support"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Need Help?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 20),

            ListTile(
              leading: Icon(Icons.email),
              title: Text("support@mgcollection.com"),
              subtitle: Text("Email us anytime"),
            ),

            Divider(),

            ListTile(
              leading: Icon(Icons.phone),
              title: Text("+91 98765 43210"),
              subtitle: Text("Mon - Sat | 9AM - 6PM"),
            ),

            Divider(),

            ListTile(
              leading: Icon(Icons.chat),
              title: Text("Live Chat"),
              subtitle: Text("Available in App Soon"),
            ),
          ],
        ),
      ),
    );
  }
}