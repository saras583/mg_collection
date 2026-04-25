import 'package:flutter/material.dart';
import 'package:mgcollection_app/screens/home_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Favorites"),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          },
          icon: Icon(Icons.backspace_rounded),
        ),
      ),
      body: Column(children: []),
    );
  }
}
