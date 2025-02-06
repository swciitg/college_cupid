import 'dart:convert';

import 'package:college_cupid/shared/database_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static Future<void> clearPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(DatabaseStrings.accessToken);
  }

  static Future<void> setAccessToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DatabaseStrings.accessToken, value);
  }

  static Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(DatabaseStrings.refreshToken);
  }

  static Future<void> setRefreshToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DatabaseStrings.refreshToken, value);
  }

  static Future<void> setEmail(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DatabaseStrings.email, value);
  }

  static Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(DatabaseStrings.email);
  }

  static Future<void> setDisplayName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DatabaseStrings.displayName, value);
  }

  static Future<String?> getDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(DatabaseStrings.displayName);
  }

  static Future<void> setDHPrivateKey(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DatabaseStrings.dhPrivateKey, value);
  }

  static Future<String?> getDHPrivateKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(DatabaseStrings.dhPrivateKey);
  }

  static Future<void> setDHPublicKey(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DatabaseStrings.dhPublicKey, value);
  }

  static Future<String?> getDHPublicKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(DatabaseStrings.dhPublicKey);
  }

  static Future<void> setRollNumber(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DatabaseStrings.rollNumber, value);
  }

  static Future<String?> getRollNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(DatabaseStrings.rollNumber);
  }

  static Future<void> saveMyProfile(Map<String, dynamic> myProfile) async {
    SharedPreferences user = await SharedPreferences.getInstance();
    await user.setString(DatabaseStrings.myProfile, jsonEncode(myProfile));
    await user.setBool(DatabaseStrings.isProfileCompleted, true);
  }

  static Future<Map<String, dynamic>> getMyProfile() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    String myProfile = user.getString(DatabaseStrings.myProfile)!;
    return jsonDecode(myProfile);
  }

  static Future<void> setOutlookInfo({
    required String accessToken,
    required String refreshToken,
    required String email,
    required String displayName,
    required String rollNumber,
  }) async {
    SharedPreferences user = await SharedPreferences.getInstance();
    await user.setString(DatabaseStrings.accessToken, accessToken);
    await user.setString(DatabaseStrings.refreshToken, refreshToken);

    await user.setString(DatabaseStrings.email, email);
    await user.setString(DatabaseStrings.displayName, displayName);
    await user.setString(DatabaseStrings.rollNumber, rollNumber);
  }

  static Future<Map<String, String>> getOutlookInfo() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    Map<String, String> info = {};
    info[DatabaseStrings.accessToken] =
        user.getString(DatabaseStrings.accessToken) ?? '';
    info[DatabaseStrings.refreshToken] =
        user.getString(DatabaseStrings.refreshToken) ?? '';

    info[DatabaseStrings.email] = user.getString(DatabaseStrings.email) ?? '';
    info[DatabaseStrings.displayName] =
        user.getString(DatabaseStrings.displayName) ?? '';
    info[DatabaseStrings.rollNumber] =
        user.getString(DatabaseStrings.rollNumber) ?? '';

    return info;
  }
}
