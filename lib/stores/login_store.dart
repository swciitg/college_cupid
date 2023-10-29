import '../services/api.dart';
import '../services/shared_prefs.dart';
import '../shared/database_strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginStore {
  static bool isProfileCompleted = false;
  static Map<String, dynamic> myProfile = {};
  static String? email;
  static String? displayName;
  static String? privateKey;
  static String? publicKey;
  static String? accessToken;
  static String? refreshToken;
  static String? password;

  static Future<bool> isAuthenticated() async {
    SharedPreferences user = await SharedPreferences.getInstance();

    if (user.containsKey(DatabaseStrings.myProfile)) {
      debugPrint('USER CONTAINS KEY');
      await initializeStore();
      Map<String, dynamic>? data = await APIService().getUserProfile(email!);
      if (data != null) {
        await SharedPrefs.saveMyProfile(data);
        await initializeMyProfile();
        isProfileCompleted = true;
      }
      return true;
    } else {
      debugPrint('USER DOES NOT CONTAIN KEY');
      return false;
    }
  }

  static Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isProfileCompleted = false;
    myProfile.clear();
    email = null;
    displayName = null;
    accessToken = null;
    refreshToken = null;
    privateKey = null;
    publicKey = null;
    password = null;
    return prefs.clear();
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

  static Future<void> initializeMyProfile() async {
    myProfile = await SharedPrefs.getMyProfile();
  }

  static Future<void> updateMyProfile(Map<String, dynamic> myProfileMap) async {
    await SharedPrefs.saveMyProfile(myProfileMap);
    myProfile = await SharedPrefs.getMyProfile();
  }
}
