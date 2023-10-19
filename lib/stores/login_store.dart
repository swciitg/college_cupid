import 'dart:convert';
import 'package:college_cupid/models/personal_info.dart';
import 'package:college_cupid/services/api.dart';
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
      Map<String, dynamic>? data = await APIService().getPersonalInfo();
      await updateEmail();
      await updateDisplayName();
      if (data != null) {
        await saveMyInfo(data);
        await updateUserData();
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

  Future<void> saveMyInfo(Map<String, dynamic> myInfo) async {
    SharedPreferences user = await SharedPreferences.getInstance();
    await user.setString('myInfo', jsonEncode(myInfo));
    await user.setBool('isProfileCompleted', true);
  }
}
