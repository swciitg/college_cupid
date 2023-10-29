import 'dart:convert';
import 'package:college_cupid/shared/database_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static Future<void> clearPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(DatabaseStrings.accessToken) ?? " ";
  }

  static Future<void> setAccessToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DatabaseStrings.accessToken, value);
  }

  static Future<String> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(DatabaseStrings.refreshToken) ?? " ";
  }

  static Future<void> setRefreshToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DatabaseStrings.refreshToken, value);
  }

  static Future<void> setEmail(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DatabaseStrings.email, value);
  }

  static Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(DatabaseStrings.email) ?? " ";
  }

  static Future<void> setDisplayName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DatabaseStrings.displayName, value);
  }

  static Future<String> getDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(DatabaseStrings.displayName) ?? " ";
  }

  static Future<void> setPrivateKey(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DatabaseStrings.privateKey, value);
  }

  static Future<String> getPrivateKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(DatabaseStrings.privateKey) ?? " ";
  }

  static Future<void> setPublicKey(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DatabaseStrings.publicKey, value);
  }

  static Future<String> getPublicKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(DatabaseStrings.publicKey) ?? " ";
  }

  static Future<void> setPassword(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DatabaseStrings.password, value);
  }

  static Future<String> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(DatabaseStrings.password) ?? " ";
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
}
