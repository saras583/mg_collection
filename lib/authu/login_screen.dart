import 'package:flutter/material.dart';
import 'package:mgcollection_app/authu/register_screen.dart';
import 'package:mgcollection_app/screens/bottomnavigationbarScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailcontroller =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool obscurePassword = true;

  bool loading = false;

  final supabase =
      Supabase.instance.client;

  /// LOGIN
  Future<void> login() async {

    setState(() {
      loading = true;
    });

    try {

      final result =
          await supabase.auth
              .signInWithPassword(

        email:
            emailcontroller.text
                .trim(),

        password:
            passwordController.text
                .trim(),
      );

      if (result.user != null) {

        Navigator.pushAndRemoveUntil(

          context,

          MaterialPageRoute(

            builder: (_) =>
                const Bottomnavigationbarscreen(),
          ),

          (route) => false,
        );
      }

    } on AuthException catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(e.message),
        ),
      );

    } finally {

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      resizeToAvoidBottomInset: true,

      backgroundColor:
          const Color(0xFFF5EFEF),

      body: SafeArea(

        child: Padding(

          padding:
              const EdgeInsets.symmetric(
            horizontal: 25,
          ),

          child: SingleChildScrollView(

            child: ConstrainedBox(

              constraints: BoxConstraints(

                minHeight:
                    MediaQuery.of(context)
                        .size
                        .height,
              ),

              child: Column(

                children: [

                  const SizedBox(height: 20),

                  /// BACK BUTTON
                  Align(

                    alignment:
                        Alignment.topLeft,

                    child: Container(

                      height: 50,

                      width: 50,

                      decoration:
                          const BoxDecoration(

                        color: Colors.white,

                        shape:
                            BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.arrow_back_ios_new,
                      ),
                    ),
                  ),

                  const SizedBox(height: 70),

                  /// TITLE
                  const Text(

                    "Hello Again!",

                    style: TextStyle(

                      fontSize: 35,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          Color(0xFF1F2937),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(

                    "Welcome Back You've Been Missed!",

                    style: TextStyle(

                      fontSize: 16,

                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 50),

                  /// EMAIL TITLE
                  const Align(

                    alignment:
                        Alignment.centerLeft,

                    child: Text(

                      "Email Address",

                      style: TextStyle(

                        fontSize: 18,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// EMAIL FIELD
                  Container(

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),
                    ),

                    child: TextField(

                      controller:
                          emailcontroller,

                      decoration:
                          const InputDecoration(

                        hintText:
                            "alissonbecker@gmail.com",

                        border:
                            InputBorder.none,

                        contentPadding:
                            EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 20,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  /// PASSWORD TITLE
                  const Align(

                    alignment:
                        Alignment.centerLeft,

                    child: Text(

                      "Password",

                      style: TextStyle(

                        fontSize: 18,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// PASSWORD FIELD
                  Container(

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),
                    ),

                    child: TextField(

                      controller:
                          passwordController,

                      obscureText:
                          obscurePassword,

                      decoration:
                          InputDecoration(

                        border:
                            InputBorder.none,

                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 20,
                        ),

                        suffixIcon:
                            IconButton(

                          icon: Icon(

                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),

                          onPressed: () {

                            setState(() {

                              obscurePassword =
                                  !obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// RECOVERY PASSWORD
                  const Align(

                    alignment:
                        Alignment.centerLeft,

                    child: Text(

                      "Recovery Password",

                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// LOGIN BUTTON
                  SizedBox(

                    width: double.infinity,

                    height: 60,

                    child: ElevatedButton(

                      style:
                          ElevatedButton.styleFrom(

                        backgroundColor:
                            const Color(
                          0xFF5DA9E9,
                        ),

                        shape:
                            RoundedRectangleBorder(

                          borderRadius:
                              BorderRadius.circular(
                            35,
                          ),
                        ),
                      ),

                      onPressed:
                          loading
                              ? null
                              : login,

                      child:
                          loading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(

                                "Sign In",

                                style: TextStyle(

                                  fontSize: 20,

                                  color: Colors.white,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// GOOGLE BUTTON
                  Container(

                    height: 60,

                    width: double.infinity,

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        35,
                      ),
                    ),

                    child: Row(

                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: const [

                        Icon(
                          Icons.g_mobiledata,
                          size: 40,
                          color: Colors.red,
                        ),

                        SizedBox(width: 10),

                        Text(

                          "Sign in with google",

                          style: TextStyle(

                            fontSize: 20,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 120),

                  /// REGISTER
                  Row(

                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      const Text(

                        "Don’t Have An Account?",

                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      GestureDetector(

                        onTap: () {

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  const RegisterScreen(),
                            ),
                          );
                        },

                        child: const Text(

                          " Sign Up For Free",

                          style: TextStyle(

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}