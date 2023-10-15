import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginStore {
  static bool isProfileCompleted = false;
  static Map<String, dynamic> userData = {};

  Future<bool> isAuthenticated() async {
    SharedPreferences user = await SharedPreferences.getInstance();

    if (user.containsKey('myInfo')) {
      //TODO: fetch user data from db and update in shared prefs
      if (user.containsKey('isProfileCompleted')) {
        isProfileCompleted = true;
      }
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateUserData() async {
    SharedPreferences user = await SharedPreferences.getInstance();

    userData = jsonDecode((user.getString('myInfo'))!);
  }
}
