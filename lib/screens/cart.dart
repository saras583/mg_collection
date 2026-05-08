import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mgcollection_app/screens/watches_details_screen.dart';

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

    return Scaffold(
      appBar: AppBar(title: Text('MyCart')),
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
                final reversedIndex = box.length - 1 - index;

                final rawItem = box.getAt(reversedIndex);

                if (rawItem == null || rawItem is! Map) {
                  return const SizedBox();
                }

                final item = Map<String, dynamic>.from(rawItem);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WatchesDetailsScreen(product: item),
                      ),
                    );
                  },

                  child: ListTile(
                    leading: Image.asset(
                      item['image'] ?? 'assets/images/placeholder.png',
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image);
                      },
                    ),

                    title: Text(item['name'] ?? 'No Name'),

                    subtitle: Text("₹${item['price'] ?? 0}"),

                    trailing: IconButton(
                      onPressed: () {
                        box.deleteAt(reversedIndex);
                      },

                      icon: const Icon(Icons.delete),
                    ),
                  ),
                );
              },
            );
          },
          child: Row(
            children: [ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  
                    
                },
                child: Text("View Order Details"),
              ),],
          ),
        ),
      ),
    );
  }
}
