import 'package:flutter/material.dart';
import 'package:mgcollection_app/screens/bottomnavigationbarScreen.dart';
import 'package:mgcollection_app/screens/getstartScreen.dart';



void main() {
  runApp(const MgCollection());
}

class MgCollection extends StatelessWidget {
  const MgCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData(primarySwatch: Colors.blue),debugShowCheckedModeBanner: false,home: Getstartscreen(),);
  }
}

