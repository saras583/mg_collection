import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mgcollection_app/screens/bottomnavigationbarScreen.dart';
import 'package:mgcollection_app/screens/login_screen.dart';
import 'package:mgcollection_app/screens/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('cart');
  await Hive.openBox('userBox');
  await Hive.openBox('authBox');

  runApp(MgCollection());
}

class MgCollection extends StatelessWidget {
  MgCollection({super.key});

  ///  CONTROLLER HERE
  final ThemeController controller = ThemeController();

  @override
  Widget build(BuildContext context) {
    var authBox = Hive.box('authBox');
    bool isLoggedIn = authBox.get('isLoggedIn', defaultValue: false);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),

          themeMode: controller.themeMode,

          
          home: isLoggedIn
              ? Bottomnavigationbarscreen(controller : controller)
              : LoginScreen(controller: controller),
        );
      },
    );
  }
}