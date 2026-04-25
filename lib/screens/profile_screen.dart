import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mgcollection_app/screens/login_screen.dart';
import 'package:mgcollection_app/screens/theme_controller.dart';

class ProfileScreen extends StatefulWidget {
  final ThemeController controller;
  const ProfileScreen({super.key, required this.controller});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool faceId = false;
  bool pushNotification = true;
  bool locationSrevice = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor
      ,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Account&Setting',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                LoginScreen(controller: widget.controller),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/images/money.jpg'),
                      ),
                    ),
                  ],
                ),
              ),
              //account part
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text('Notification setting'),
                      trailing: Icon(Icons.arrow_forward, size: 16),
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_cart),
                      title: Text('shoping address'),
                      trailing: Icon(Icons.arrow_forward, size: 16),
                    ),
                    ListTile(
                      leading: Icon(Icons.payment),
                      title: Text('Payment info'),
                      trailing: Icon(Icons.arrow_forward, size: 16),
                    ),
                    ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Delete Account'),
                      trailing: Icon(Icons.arrow_forward, size: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              // app setting
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    SwitchListTile(
                      value: false,
                      onChanged: (val) {},
                      title: Text('Enable face Id for log in'),
                    ),
                    SwitchListTile(
                      value: true,
                      onChanged: (val) {},
                      title: Text('Enable Push Notification'),
                    ),
                    SwitchListTile(
                      value: true,
                      onChanged: (val) {},
                      title: Text('Enable Location Service'),
                    ),
                    SwitchListTile(
                      value: widget.controller.themeMode == ThemeMode.dark,
                      onChanged: (val) {
                        widget.controller.toggleTheme(val);
                      },
                      title: Text('Dark mode'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        logout(context);
                      },
                      child: Text("Logout"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
      ),
    );
  }

  void logout(BuildContext context) {
    var authBox = Hive.box('authBox');

    authBox.put('isLoggedIn', false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(controller: ThemeController()),
      ),
      (route) => false,
    );
  }
}
