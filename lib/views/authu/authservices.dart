import 'package:hive/hive.dart';

class Authservices {
  final Box box = Hive.box('authBox');

  // save login data

  Future<void> login(String username, String password) async {
    await box.put('username', username);
    await box.put('password', password);
    await box.put('isLoggedIn', true);
  }

  //check login
  bool isLoggedIn() {
    return box.get('isLoggedIn', defaultValue: false);
  }

  //logout
  Future<void> logout() async {
    await box.clear();
  }

  //get user
  String getusername() {
    return box.get("username", defaultValue: '');
  }
}
