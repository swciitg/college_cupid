import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/shared_prefs.dart';
import '../shared/database_strings.dart';

class LoginStore {
  static bool isProfileCompleted = false;
  static bool isPasswordSaved = false;

  static String? email;
  static String? displayName;
  static String? dhPrivateKey;
  static String? dhPublicKey;
  static String? accessToken;
  static String? refreshToken;
  static String? password;
  static String? rollNumber;

  static Future<bool> isAuthenticated() async {
    SharedPreferences user = await SharedPreferences.getInstance();

    if (user.containsKey(DatabaseStrings.myProfile)) {
      debugPrint('USER CONTAINS KEY');
      await initializeStore();
      if ((password ?? "").isNotEmpty) isPasswordSaved = true;
      Map<String, dynamic>? data =
          await UserProfileRepository().getUserProfile(email!);
      if (data != null) {
        await SharedPrefs.saveMyProfile(data);
        // await initializeMyProfile();
        isProfileCompleted = true;
      } else {
        await logout();
        return false;
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
    isPasswordSaved = false;
    // myProfile.clear();
    email = null;
    displayName = null;
    accessToken = null;
    refreshToken = null;
    dhPrivateKey = null;
    dhPublicKey = null;
    password = null;
    rollNumber = null;
    return prefs.clear();
  }

  static Future<void> initializeStore() async {
    await initializeDisplayName();
    await initializeEmail();
    await initializeTokens();
    await initializeKeys();
    await initializeRollNumber();
    await initializePassword();
  }

  static Future<void> initializeOutlookInfo() async {
    Map<String, String> info = await SharedPrefs.getOutlookInfo();
    LoginStore.accessToken = info[DatabaseStrings.accessToken];
    LoginStore.refreshToken = info[DatabaseStrings.refreshToken];
    LoginStore.email = info[DatabaseStrings.email];
    LoginStore.rollNumber = info[DatabaseStrings.rollNumber];
    LoginStore.displayName = info[DatabaseStrings.displayName];
  }

  static Future<void> initializeRollNumber() async {
    rollNumber = await SharedPrefs.getRollNumber();
  }

  static Future<void> initializeTokens() async {
    accessToken = await SharedPrefs.getAccessToken();
    refreshToken = await SharedPrefs.getRefreshToken();
  }

  static Future<void> initializeKeys() async {
    dhPrivateKey = await SharedPrefs.getDHPrivateKey();
    dhPublicKey = await SharedPrefs.getDHPublicKey();
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
}
