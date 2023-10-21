import 'dart:convert';
import 'package:college_cupid/globals/database_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static Future<void> clearPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(BackendHelper.accessToken) ?? " ";
  }

  static Future<void> setAccessToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(BackendHelper.accessToken, value);
  }

  static Future<String> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(BackendHelper.refreshToken) ?? " ";
  }

  static Future<void> setRefreshToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(BackendHelper.refreshToken, value);
  }

  static Future<void> setEmail(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(BackendHelper.email, value);
  }

  static Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(BackendHelper.email) ?? " ";
  }

  static Future<void> setDisplayName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(BackendHelper.displayName, value);
  }

  static Future<String> getDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(BackendHelper.displayName) ?? " ";
  }

  static Future<void> setPrivateKey(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(BackendHelper.privateKey, value);
  }

  static Future<String> getPrivateKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(BackendHelper.privateKey) ?? " ";
  }

  static Future<void> setPublicKey(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(BackendHelper.publicKey, value);
  }

  static Future<String> getPublicKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(BackendHelper.publicKey) ?? " ";
  }

  static Future<void> setPassword(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(BackendHelper.password, value);
  }

  static Future<String> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(BackendHelper.password) ?? " ";
  }

  static Future<void> saveMyInfo(Map<String, dynamic> myInfo) async {
    SharedPreferences user = await SharedPreferences.getInstance();
    await user.setString('myInfo', jsonEncode(myInfo));
    await user.setBool('isProfileCompleted', true);
  }

  static Future<Map<String, dynamic>> getMyInfo() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    String myInfo = user.getString('myInfo')!;
    return jsonDecode(myInfo);
  }
}
