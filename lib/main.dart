import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mgcollection_app/screens/bottomnavigationbarScreen.dart';
import 'package:mgcollection_app/screens/getstartScreen.dart';
import 'package:mgcollection_app/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('cart');
  await Hive.openBox('userBox');//userdata   
  await Hive.openBox('authBox');//store login state

  runApp(MgCollection());
}

class MgCollection extends StatelessWidget {
  const MgCollection({super.key});

  @override
  Widget build(BuildContext context) {
    var authBox = Hive.box('authBox');
    bool isLoggedIn = authBox.get('isLoggedIn', defaultValue: false);

    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
          ? Bottomnavigationbarscreen()   // already logged in
          : LoginScreen(),                // go to login
    
    );
  }
}
