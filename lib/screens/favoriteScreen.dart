import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mgcollection_app/screens/shirt_details_screen.dart';
import 'package:mgcollection_app/screens/shoes_detailed_screen.dart';
import 'package:mgcollection_app/screens/watches_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    var favBox = Hive.box('favorites');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Favorites"),
      ),
      body: ValueListenableBuilder(
        valueListenable: favBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return Center(child: Text("No favorites yet"));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final rawItem = box.getAt(index);

              if (rawItem == null || rawItem is! Map) {
                return SizedBox();
              }
              final item = Map<String, dynamic>.from(rawItem);

              return GestureDetector(
                onTap: () {
                  if (item['name'] == 'wathes') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WatchesDetailsScreen(product: item),
                      ),
                    );
                  } else if (item['name'] == 'Nike Jordan') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ShoesDetailsScreen(product: item),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ShirtDetailsScreen(product: item),
                      ),
                    );
                  }
                },
                child: ListTile(
                  leading: Image.asset(item['image'], width: 50, height: 50),
                  title: Text(item['name']),
                  subtitle: Text("₹${item['price']}"),
                  trailing: IconButton(
                    onPressed: () {
                      box.deleteAt(index);
                    },
                    icon: Icon(Icons.favorite, color: Colors.red),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
