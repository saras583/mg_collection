import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {

  final emailController =
      TextEditingController();

  final newPasswordController =
      TextEditingController();

  bool obscurePassword = true;

  
  void resetPassword() {

    String email =
        emailController.text
            .trim()
            .toLowerCase();

    String newPassword =
        newPasswordController.text
            .trim();

    if (email.isEmpty ||
        newPassword.isEmpty) {

      showMsg(
        "Fill all fields",
      );

      return;
    }

    var userBox =
        Hive.box('userBox');

    List users =
        userBox.get(
          'users',
          defaultValue: [],
        );

    int userIndex =
        users.indexWhere(

      (u) =>

          u['email']
                  .toString()
                  .toLowerCase() ==
              email,
    );

    if (userIndex != -1) {

      users[userIndex]['password'] =
          newPassword;

      userBox.put(
        'users',
        users,
      );

      showMsg(
        "Password Updated",
      );

      Navigator.pop(context);

    } else {

      showMsg(
        "User not found",
      );
    }
  }

  
  void showMsg(String msg) {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(
        content: Text(msg),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text("Forgot Password"),
      ),

      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

      body: Padding(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            const SizedBox(height: 40),

            
            TextField(

              controller:
                  emailController,

              decoration:
                  InputDecoration(

                hintText:
                    "Enter Email",

                filled: true,

                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    30,
                  ),

                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            
            TextField(

              controller:
                  newPasswordController,

              obscureText:
                  obscurePassword,

              decoration:
                  InputDecoration(

                hintText:
                    "New Password",

                filled: true,

                fillColor:
                    Colors.white,

                suffixIcon:
                    IconButton(

                  icon: Icon(

                    obscurePassword
                        ? Icons
                            .visibility_off
                        : Icons.visibility,
                  ),

                  onPressed: () {

                    setState(() {

                      obscurePassword =
                          !obscurePassword;
                    });
                  },
                ),

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    30,
                  ),

                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            
            GestureDetector(

              onTap: resetPassword,

              child: Container(

                width: double.infinity,

                padding:
                    const EdgeInsets.symmetric(
                  vertical: 16,
                ),

                decoration: BoxDecoration(

                  color: Colors.blue,

                  borderRadius:
                      BorderRadius.circular(
                    30,
                  ),
                ),

                child: const Center(

                  child: Text(

                    "Reset Password",

                    style: TextStyle(

                      color: Colors.white,

                      fontWeight:
                          FontWeight.bold,

                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}