import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/shared_prefs.dart';
import '../shared/database_strings.dart';

class LoginStore {
  static bool isProfileCompleted = false;

  static String? email;
  static String? displayName;
  static String? dhPrivateKey;
  static String? dhPublicKey;
  static String? accessToken;
  static String? refreshToken;
  static String? rollNumber;

  static Future<bool> isAuthenticated() async {
    SharedPreferences user = await SharedPreferences.getInstance();

    if (user.containsKey(DatabaseStrings.myProfile)) {
      debugPrint('USER CONTAINS KEY');
      await initializeStore();
      final data = await UserProfileRepository().getUserProfile(email!);
      if (data != null) {
        await SharedPrefService.saveMyProfile(data);
        isProfileCompleted = true;
      } else {
        // TODO: Don't logout if internet is turned-off
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

    email = null;
    displayName = null;
    accessToken = null;
    refreshToken = null;
    dhPrivateKey = null;
    dhPublicKey = null;
    rollNumber = null;
    return prefs.clear();
  }

  static Future<void> initializeStore() async {
    await initializeDisplayName();
    await initializeEmail();
    await initializeTokens();
    await initializeKeys();
    await initializeRollNumber();
  }

  static Future<void> initializeOutlookInfo() async {
    Map<String, String> info = await SharedPrefService.getOutlookInfo();
    LoginStore.accessToken = info[DatabaseStrings.accessToken];
    LoginStore.refreshToken = info[DatabaseStrings.refreshToken];
    LoginStore.email = info[DatabaseStrings.email];
    LoginStore.rollNumber = info[DatabaseStrings.rollNumber];
    LoginStore.displayName = info[DatabaseStrings.displayName];
  }

  static Future<void> initializeRollNumber() async {
    rollNumber = await SharedPrefService.getRollNumber();
  }

  static Future<void> initializeTokens() async {
    accessToken = await SharedPrefService.getAccessToken();
    refreshToken = await SharedPrefService.getRefreshToken();
  }

  static Future<void> initializeKeys() async {
    dhPrivateKey = await SharedPrefService.getDHPrivateKey();
    dhPublicKey = await SharedPrefService.getDHPublicKey();
  }

  static Future<void> initializeEmail() async {
    email = await SharedPrefService.getEmail();
  }

  static Future<void> initializeDisplayName() async {
    displayName = await SharedPrefService.getDisplayName();
  }
}
