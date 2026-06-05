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
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);

        debugPrint('========== FLUTTER ERROR ==========');
        debugPrint(details.exceptionAsString());
        debugPrint(details.stack.toString());
      };

      await dotenv.load(fileName: '.env');

      await Hive.initFlutter();

      await Future.wait([
        Hive.openBox('favorites'),
        Hive.openBox('cart'),
        Hive.openBox('orders'),
        Hive.openBox('settings'),
        Hive.openBox('products'),
        Hive.openBox('adminBox'),
      ]);

      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

      if (supabaseUrl == null ||
          supabaseUrl.isEmpty ||
          supabaseAnonKey == null ||
          supabaseAnonKey.isEmpty) {
        throw Exception('Missing Supabase environment variables');
      }

      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );

      runApp(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: const MgCollection(),
        ),
      );
    },
    (error, stackTrace) {
      debugPrint('========== UNHANDLED ERROR ==========');
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
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: provider.themeData == darkTheme
              ? ThemeMode.dark
              : ThemeMode.light,
          home: const OnboardingController(),
        );
      },
    );
  }
}