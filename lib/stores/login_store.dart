import 'dart:convert';
import 'package:college_cupid/services/auth_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginStore {
  static bool isProfileCompleted = false;
  static Map<String, dynamic> userData = {};
  static String? email;
  static String? displayName;

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

  Future<void> updateEmail() async {
    email = await AuthUserHelpers.getEmail();
  }

  Future<void> updateDisplayName() async {
    displayName = await AuthUserHelpers.getDisplayName();
  }

  Future<void> updateUserData() async {
    SharedPreferences user = await SharedPreferences.getInstance();

    userData = jsonDecode((user.getString('myInfo'))!);
  }
}
