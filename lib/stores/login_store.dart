import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/services/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginStore {
  static bool isProfileCompleted = false;
  static Map<String, dynamic> myInfo = {};
  static String? email;
  static String? displayName;
  static String? privateKey;
  static String? publicKey;
  static String? accessToken;
  static String? refreshToken;
  static String? password;

  static Future<bool> isAuthenticated() async {
    SharedPreferences user = await SharedPreferences.getInstance();

    if (user.containsKey('myInfo')) {
      debugPrint('USER CONTAINS KEY');
      await initializeStore();
      Map<String, dynamic>? data = await APIService().getPersonalInfo();
      if (data != null) {
        await SharedPrefs.saveMyInfo(data);
        await initializeMyInfo();
        isProfileCompleted = true;
      }
      return true;
    } else {
      debugPrint('USER DOES NOT CONTAIN KEY');
      return false;
    }
  }

  static Future<void> initializeStore() async {
    await initializeDisplayName();
    await initializeEmail();
    await initializeTokens();
    await initializeKeys();
    await initializePassword();
  }

  static Future<void> initializeTokens() async {
    accessToken = await SharedPrefs.getAccessToken();
    refreshToken = await SharedPrefs.getRefreshToken();
  }

  static Future<void> initializeKeys() async {
    privateKey = await SharedPrefs.getPrivateKey();
    publicKey = await SharedPrefs.getPublicKey();
  }

  static Future<void> initializePassword() async {
    password = await SharedPrefs.getPassword();
  }

  static Future<void> initializeEmail() async {
    email = await SharedPrefs.getEmail();
  }

  static Future<void> initializeDisplayName() async {
    displayName = await SharedPrefs.getDisplayName();
  }

  static Future<void> initializeMyInfo() async {
    myInfo = await SharedPrefs.getMyInfo();
  }
}
