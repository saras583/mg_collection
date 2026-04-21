import 'package:flutter/material.dart';

class Checkoutpage extends StatelessWidget {
  const Checkoutpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 249, 229, 229),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey.shade200,
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                  Text(
                    'Checkout',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //contactinformation
                  Text(
                    'contact Information',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Widget_infowRow(
                    icon: Icons.email_outlined,
                    title: "mail@gmail.com",
                    subtitle: "Email",
                  ),
                  SizedBox(height: 10,),
                  Widget_infowRow(icon: Icons.phone_outlined,
  title: "+88-692-764-269",
  subtitle: "Phone",),
  SizedBox(height: 10,),
  Widget_infowRow(icon: Icons.email_outlined,
                    title: "address",
                    subtitle: "Kinfra ",),
                    
                    
                    

                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(

            )
          ],
        ),
      ),
    );
  }
}

 Widget_infowRow({
  required IconData icon,
  required String title,
  required String subtitle,
}) {
  return Row(
    children: [
      CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey.shade200,
        child: Icon(icon, color: Colors.black),
      ),
      SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(subtitle, style: TextStyle(color: Colors.grey)),
        ],
  )],
  );
}
