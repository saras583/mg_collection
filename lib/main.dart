import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'package:mgcollection_app/screens/bottomnavigationbarScreen.dart';
import 'package:mgcollection_app/screens/login_screen.dart';

import 'package:mgcollection_app/screens/theme.dart';
import 'package:mgcollection_app/services/themeprovider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('favorites');
  await Hive.openBox('cart');
  await Hive.openBox('userBox');
  await Hive.openBox('authBox');
  await Hive.openBox('orders');
  await Hive.openBox('settings');
  await Hive.openBox('products');

  runApp(

    ChangeNotifierProvider(

      create: (_) => ThemeProvider(),

      child: const MgCollection(),
    ),
  );
}

class MgCollection extends StatelessWidget {

  const MgCollection({super.key});

  @override
  Widget build(BuildContext context) {

    var authBox = Hive.box('authBox');

    bool isLoggedIn =
        authBox.get(
          'isLoggedIn',
          defaultValue: false,
        );

    return Consumer<ThemeProvider>(

      builder: (context, provider, child) {

        return MaterialApp(

          debugShowCheckedModeBanner: false,

          theme: lightTheme,

          darkTheme: darkTheme,

          themeMode:
              provider.themeData == darkTheme
                  ? ThemeMode.dark
                  : ThemeMode.light,

          home: isLoggedIn
              ? const Bottomnavigationbarscreen()
              : const LoginScreen(),
        );
      },
    );
  }
}