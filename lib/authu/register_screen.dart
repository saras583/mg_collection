import 'package:flutter/material.dart';
import 'package:mgcollection_app/authu/login_screen.dart';
import 'package:mgcollection_app/screens/bottomnavigationbarScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final nameController =
      TextEditingController();

  final emailcontroller =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool obscurePassword = true;

  bool loading = false;

  final supabase =
      Supabase.instance.client;

  /// REGISTER
  Future<void> register() async {

    setState(() {
      loading = true;
    });

    try {

      final result =
          await supabase.auth.signUp(

        email:
            emailcontroller.text
                .trim(),

        password:
            passwordController.text
                .trim(),

        data: {

          'name':
              nameController.text
                  .trim(),
        },
      );

      if (result.user != null) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content: Text(
              "Registration Successful",
            ),
          ),
        );

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

                    child: GestureDetector(

                      onTap: () {

                        Navigator.pop(
                          context,
                        );
                      },

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
                  ),

                  const SizedBox(height: 50),

                  /// TITLE
                  const Text(

                    "Create Account",

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

                    "Register to continue shopping",

                    style: TextStyle(

                      fontSize: 16,

                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// NAME TITLE
                  const Align(

                    alignment:
                        Alignment.centerLeft,

                    child: Text(

                      "Name",

                      style: TextStyle(

                        fontSize: 18,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// NAME FIELD
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
                          nameController,

                      decoration:
                          const InputDecoration(

                        hintText:
                            "Enter Name",

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

                  const SizedBox(height: 30),

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

                      keyboardType:
                          TextInputType.emailAddress,

                      decoration:
                          const InputDecoration(

                        hintText:
                            "example@gmail.com",

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

                  const SizedBox(height: 30),

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
                            hintText: 'password',

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

                  const SizedBox(height: 40),

                  /// REGISTER BUTTON
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
                              : register,

                      child:
                          loading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(

                                "Sign Up",

                                style: TextStyle(

                                  fontSize: 20,

                                  color: Colors.white,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  /// LOGIN
                  Row(

                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      const Text(

                        "Already have an account?",

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
                                  const LoginScreen(),
                            ),
                          );
                        },

                        child: const Text(

                          " Login",

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