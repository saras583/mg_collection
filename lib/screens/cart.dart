import 'package:flutter/material.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('cart'),backgroundColor: Color(0xFFE6E6FAe),),
    floatingActionButton:FloatingActionButton(onPressed: (){

    },child:Text('add') ,) ,
    body:Column(children: [SizedBox(height: 21

    
    ,),TextField(decoration: InputDecoration(
                hintText: 'search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  
                ),)),Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 250,
                    child: Center(child: Text('cart is emty and add to cart'),)
                  ),
                )],));
  }
}
