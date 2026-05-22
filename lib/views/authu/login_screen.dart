import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/admin/screens/admin_home.dart';
import 'package:mgcollection_app/views/authu/register_screen.dart';
import 'package:mgcollection_app/views/user/screens/bottomnavigationbarScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool obscurePassword = true;

  bool loading = false;

  final supabase =
      Supabase.instance.client;

  /// EMAIL LOGIN
  Future<void> login() async {

    setState(() {
      loading = true;
    });

    try {

      final email =
          emailController.text.trim();

      final password =
          passwordController.text.trim();

      /// ADMIN LOGIN
      if (

        email == "admin@gmail.com" &&
        password == "123456"

      ) {

        Navigator.pushAndRemoveUntil(

          context,

          MaterialPageRoute(

            builder: (_) =>
                const AdminHome(),
          ),

          (route) => false,
        );

        return;
      }

      /// USER LOGIN
      final result =
          await supabase.auth
              .signInWithPassword(

        email: email,

        password: password,
      );

      final user =
          result.user;

      if (user != null) {

        /// CHECK USER EXISTS
        final existingUser =
            await supabase
                .from('users')
                .select()
                .eq('id', user.id);

        /// INSERT USER
        if (existingUser.isEmpty) {

          await supabase
              .from('users')
              .insert({

            "id":
                user.id,

            "name":
                user.userMetadata?['full_name']
                    ?? "User",

            "email":
                user.email,

            "joined":
                DateTime.now()
                    .toString()
                    .substring(0, 10),

            "blocked":
                false,
          });
        }

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
          content: Text(
            e.message,
          ),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );

    } finally {

      setState(() {
        loading = false;
      });
    }
  }

  /// GOOGLE LOGIN
  Future<void> continueWithGoogle() async {

    try {

      await supabase.auth.signInWithOAuth(

        OAuthProvider.google,
      );

      /// LISTEN LOGIN
      supabase.auth.onAuthStateChange.listen(

        (data) async {

          final session =
              data.session;

          if (session != null) {

            final user =
                session.user;

            /// CHECK USER EXISTS
            final existingUser =
                await supabase
                    .from('users')
                    .select()
                    .eq('id', user.id);

            /// INSERT USER
            if (existingUser.isEmpty) {

              await supabase
                  .from('users')
                  .insert({

                "id":
                    user.id,

                "name":
                    user.userMetadata?[
                            'full_name'] ??
                        "Google User",

                "email":
                    user.email,

                "joined":
                    DateTime.now()
                        .toString()
                        .substring(0, 10),

                "blocked":
                    false,
              });
            }

            /// GO HOME
            if (mounted) {

              Navigator.pushAndRemoveUntil(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                      const Bottomnavigationbarscreen(),
                ),

                (route) => false,
              );
            }
          }
        },
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {

    emailController.dispose();

    passwordController.dispose();

    super.dispose();
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
                          emailController,

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

                        hintText:
                            "Enter Password",

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
                                  color:
                                      Colors.white,
                                )

                              : const Text(

                                  "Sign In",

                                  style: TextStyle(

                                    fontSize: 20,

                                    color:
                                        Colors.white,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// GOOGLE BUTTON
                  GestureDetector(

                    onTap:
                        continueWithGoogle,

                    child: Container(

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

                          Image(

                            image: AssetImage(
                              'assets/images/search.png',
                            ),

                            height: 25,
                          ),

                          SizedBox(width: 15),

                          Text(

                            "Sign in with Google",

                            style: TextStyle(

                              fontSize: 20,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),

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

                          " Sign Up For free",

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