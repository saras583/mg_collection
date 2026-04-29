import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var favBox = Hive.box('favorites');

    return Scaffold(
      appBar: AppBar(title: Text("Favorites")),
      body: ValueListenableBuilder(
        valueListenable: favBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return Center(
              child: Text("No favorites yet"),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final item = box.getAt(index);

              return ListTile(
                leading: Image.asset(item['image']),
                title: Text(item['name']),
                subtitle: Text("₹${item['price']}"),
                trailing: IconButton(
                  onPressed: () {
                    box.deleteAt(index);
                  },
                  icon: Icon(Icons.favorite, color: Colors.red),
                ),
              );
            },
          );
        },
      ),
    );
  }
}