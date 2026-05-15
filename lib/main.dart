
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mgcollection_app/authu/splash_screen.dart';
import 'package:mgcollection_app/controller.onbording/onbordingcontroller.dart';
import 'package:mgcollection_app/controller.onbording/onbordingscreen.dart';
import 'package:provider/provider.dart';
import 'package:mgcollection_app/screens/theme.dart';
import 'package:mgcollection_app/services/themeprovider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  


  await Hive.initFlutter();
  await Supabase.initialize(

  url: 'https://slpdclrwwipermdrawaj.supabase.co',

  anonKey: 'sb_publishable_d4jN79-vzp42GJdZ1UbwGw_uxtsqlT9',
);

  /// OPEN HIVE 
  await Hive.openBox('favorites');
  await Hive.openBox('cart');
  await Hive.openBox('orders');
  await Hive.openBox('settings');
  await Hive.openBox('products');
  await Hive.openBox('adminBox'); 

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

    return Consumer<ThemeProvider>(

      builder: (context, provider, child) {

        return MaterialApp(

          debugShowCheckedModeBanner: false,

          /// LIGHT THEME
          theme: lightTheme,

          /// DARK THEME
          darkTheme: darkTheme,

          /// THEME MODE
          themeMode:
              provider.themeData == darkTheme
                  ? ThemeMode.dark
                  : ThemeMode.light,

          /// APP FLOW CONTROLLER
          home: const OnboardingScreen()
        );
      },
    );
  }
}