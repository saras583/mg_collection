import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mgcollection_app/models/controller.onbording/onbordingscreen.dart';
import 'package:mgcollection_app/views/authu/login_screen.dart';
import 'package:mgcollection_app/views/user/screens/bottomnavigationbarScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

    final session =
        Supabase.instance.client
            .auth.currentSession;

    /// FIRST TIME
    if (!onboardingDone) {

      return const OnboardingScreen();
    }

    /// AUTO LOGIN
    else if (session != null) {

      return const Bottomnavigationbarscreen();
    }

    /// LOGIN SCREEN
    else {

      return const LoginScreen();
    }
  }
}