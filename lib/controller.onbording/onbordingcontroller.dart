import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mgcollection_app/screens/login_screen.dart';
import 'package:mgcollection_app/screens/onbordingscreen.dart';

class OnboardingController
    extends StatelessWidget {

  const OnboardingController({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    var settingsBox =
        Hive.box('settings');

    bool onboardingDone =
        settingsBox.get(
          'onboardingDone',
          defaultValue: false,
        );

    if (onboardingDone) {

      return const LoginScreen();

    } else {

      return const OnboardingScreen();
    }
  }
}