import 'package:flutter/material.dart';
import 'package:mgcollection_app/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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
      backgroundColor: Color(0xFFF5EFEF),
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
                          MaterialPageRoute(builder: (_) => LoginScreen()),
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
                      value: false,
                      onChanged: (val) {},
                      title: Text('Dark mode'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        logout();
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

  void logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();

    await pref.setBool('isloggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }
}
