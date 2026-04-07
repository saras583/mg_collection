import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),leading: Container(),
      ),
      body: Center(
        child: Text("Your Favorite Items "),
      ),
    );
  }
}