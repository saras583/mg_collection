import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<int> quantity = [1, 1, 1];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EFEF),
    body: SafeArea(child: Column(
      children: [
        Padding(padding: EdgeInsets.all(10),
        child: Row(children: [
          CircleAvatar(backgroundColor: Colors.white,
          child: Icon(Icons.arrow_back)),
          SizedBox(width: 100,)
          ,Text('My Cart',style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.bold),),

        ],),),
        //cartitems
        Expanded(child: ListView(
          children: [
            
          ],
        ))
      ],
    )),);
  }
}
