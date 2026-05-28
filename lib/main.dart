import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mgcollection_app/models/controller.onbording/onbordingcontroller.dart';
import 'package:mgcollection_app/services/themeprovider.dart';
import 'package:mgcollection_app/views/user/screens/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runZonedGuarded(
    () async {
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);

        debugPrint("========== FLUTTER ERROR ==========");
        debugPrint(details.exceptionAsString());
        debugPrint(details.stack.toString());
      };

      /// LOAD ENV
      await dotenv.load(fileName: ".env");

      /// HIVE INIT
      await Hive.initFlutter();

      /// OPEN HIVE BOXES
      await Hive.openBox('favorites');
      await Hive.openBox('cart');
      await Hive.openBox('orders');
      await Hive.openBox('settings');
      await Hive.openBox('products');
      await Hive.openBox('adminBox');

      /// SUPABASE INIT
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL'] ?? '',
        anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
      );

      runApp(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: const MgCollection(),
        ),
      );
    },
    (error, stackTrace) {
      debugPrint("========== UNHANDLED ERROR ==========");
      debugPrint(error.toString());
      debugPrint(stackTrace.toString());
    },
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
          themeMode: provider.themeData == darkTheme
              ? ThemeMode.dark
              : ThemeMode.light,

          /// TEST SCREEN
          home: OnboardingController(),

          // AFTER TESTING CHANGE TO:
          // home: const OnboardingController(),
        );
      },
    );
  }
}