import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mgcollection_app/models/controller.onbording/onbordingcontroller.dart';
import 'package:provider/provider.dart';
import 'package:mgcollection_app/views/user/screens/theme.dart';
import 'package:mgcollection_app/services/themeprovider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /// LOAD ENV
  await dotenv.load(
    fileName: ".env",
  );

  /// HIVE
  await Hive.initFlutter();

  /// SUPABASE
  await Supabase.initialize(

    url:
        dotenv.env['SUPABASE_URL']!,

    anonKey:
        dotenv.env['SUPABASE_ANON_KEY']!,
  );

  /// OPEN HIVE BOXES
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

  const MgCollection({
    super.key,
  });

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

          /// APP FLOW
          home:
              const OnboardingController(),
        );
      },
    );
  }
}