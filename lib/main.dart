import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mgcollection_app/screens/bottomnavigationbarScreen.dart';
import 'package:mgcollection_app/screens/getstartScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('users');
  await Hive.openBox('authu');

  runApp(const MgCollection());
}

class MgCollection extends StatelessWidget {
  const MgCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: Getstartscreen(),
    );
  }
}
