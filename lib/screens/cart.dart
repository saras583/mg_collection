import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<int> quantity = [1, 1, 1];
  @override
  Widget build(BuildContext context) {
    var box = Hive.box('cart');

    return Scaffold( appBar: AppBar( title: Text('MyCart',),),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box box, _) {
            if (box.isEmpty) {
              return Center(child: Text('Cart is emty'));
            }
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (BuildContext context, int index) {
                final items = box.getAt(index);
                if (items == null) return SizedBox();
                return ListTile(
                  leading: Image(image: AssetImage(items['image']??'assets/images/placeholder.png')),
                  title: Text(items['name']),
                  subtitle: Text("₹${items['price']}"),
                  trailing: IconButton(
                    onPressed: () {
                      box.deleteAt(index);
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
