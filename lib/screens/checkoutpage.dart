import 'package:flutter/material.dart';

class Checkoutpage extends StatelessWidget {
  final Map<String, dynamic> product;


  const Checkoutpage({super.key,required this.product});

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
                    SizedBox(height: 10,),
                    Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                      child: Image.asset('assets/images/locationimage.png',fit: BoxFit.cover,),),
                      Widget_infowRow(
                    icon: Icons.email_outlined,
                    title: "paymentMethod",
                    subtitle: "paypal Card",
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
  ),

  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      /// 🔹 SUBTOTAL
      _priceRow("Subtotal", "₹${product['price']}"),

      SizedBox(height: 10),

      /// 🔹 SHIPPING
      _priceRow("Shipping", "\$40.90"),

      Divider(height: 20, thickness: 1),

      /// 🔹 TOTAL
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total Cost",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Row(
  children: [
    Image.asset(
      product['image'],
      height: 50,
      width: 50,
    ),
    SizedBox(width: 10),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product['name']),
        Text("₹${product['price']}"),
      ],
    )
  ],
),
SizedBox(height: 10),
          Text(
            "₹${product['price'] + 40}", 
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),

      SizedBox(height: 20),

      ///  PAYMENT BUTTON
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            "Payment",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
  ),
)
          ],
        ),
      ),
    );
  }
}

Widget _priceRow(String title, String price) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: TextStyle(color: Colors.grey)),
      Text(price, style: TextStyle(fontWeight: FontWeight.bold)),
    ],
  );
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
