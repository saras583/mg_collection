import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mgcollection_app/authu/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {

  final PageController controller =
      PageController();

  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

      body: SafeArea(

        child: Padding(

          padding:
              const EdgeInsets.all(20),

          child: Column(

            children: [

              /// SKIP BUTTON
              Align(

                alignment:
                    Alignment.topRight,

                child: TextButton(

                  onPressed: finishOnboarding,

                  child: const Text(
                    "Skip",
                  ),
                ),
              ),

              /// PAGE VIEW
              Expanded(

                child: PageView(

                  controller: controller,

                  onPageChanged: (index) {

                    setState(() {

                      isLastPage =
                          index == 2;
                    });
                  },

                  children: [

                    buildPage(

                      image:
                          'assets/images/Onboardingimage/splash-screen-image1.png',

                      title:
                          'Discover Products',

                      subtitle:
                          'Find the best products for your lifestyle.',
                    ),

                    buildPage(

                      image:
                          'assets/images/Onboardingimage/10281702.jpg',

                      title:
                          'Easy Shopping',

                      subtitle:
                          'Add products to cart and shop easily.',
                    ),

                    buildPage(

                      image:
                          'assets/images/Onboardingimage/Group of customers shopping in online store and huge tablet.jpg',

                      title:
                          'Fast Delivery',

                      subtitle:
                          'Get your orders delivered quickly.',
                    ),
                  ],
                ),
              ),

              /// INDICATOR
              SmoothPageIndicator(

                controller: controller,

                count: 3,

                effect:
                    const WormEffect(

                  dotHeight: 10,

                  dotWidth: 10,

                  activeDotColor:
                      Colors.blue,
                ),
              ),

              const SizedBox(height: 30),

              /// BUTTON
              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  style:
                      ElevatedButton.styleFrom(

                    backgroundColor:
                        Colors.blue,

                    foregroundColor:
                        Colors.white,

                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 16,
                    ),

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),
                    ),
                  ),

                  onPressed: () {

                    if (isLastPage) {

                      finishOnboarding();

                    } else {

                      controller.nextPage(

                        duration:
                            const Duration(
                          milliseconds: 500,
                        ),

                        curve:
                            Curves.easeInOut,
                      );
                    }
                  },

                  child: Text(

                    isLastPage
                        ? "Get Started"
                        : "Next",

                    style: const TextStyle(

                      fontSize: 16,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// PAGE UI
  Widget buildPage({

    required String image,

    required String title,

    required String subtitle,
  }) {

    return Column(

      mainAxisAlignment:
          MainAxisAlignment.center,

      children: [

        Image.asset(

          image,

          height: 300,
        ),

        const SizedBox(height: 40),

        Text(

          title,

          textAlign: TextAlign.center,

          style: TextStyle(

            fontSize: 28,

            fontWeight:
                FontWeight.bold,

            color:
                Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color,
          ),
        ),

        const SizedBox(height: 20),

        Text(

          subtitle,

          textAlign: TextAlign.center,

          style: const TextStyle(

            fontSize: 16,

            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  /// FINISH
  void finishOnboarding() {

    var settingsBox =
        Hive.box('settings');

    settingsBox.put(
      'onboardingDone',
      true,
    );

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (_) =>
            const LoginScreen(),
      ),
    );
  }
}