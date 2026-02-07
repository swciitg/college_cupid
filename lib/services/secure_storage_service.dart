import 'package:college_cupid/shared/database_strings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static Future<void> setOutlookAccessToken(String value) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: DatabaseStrings.outlookAccessToken, value: value);
  }

  static Future<String?> getOutlookAccessToken() async {
    const storage = FlutterSecureStorage();
    return storage.read(key: DatabaseStrings.outlookAccessToken);
  }

  static Future<void> setOutlookRefreshToken(String value) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: DatabaseStrings.outlookRefreshToken, value: value);
  }

  static Future<String?> getOutlookRefreshToken() async {
    const storage = FlutterSecureStorage();
    return storage.read(key: DatabaseStrings.outlookRefreshToken);
  }

  // Google Drive token methods
  static Future<void> setGoogleAccessToken(String value) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: DatabaseStrings.googleAccessToken, value: value);
  }

  static Future<String?> getGoogleAccessToken() async {
    const storage = FlutterSecureStorage();
    return storage.read(key: DatabaseStrings.googleAccessToken);
  }

  static Future<void> setGoogleRefreshToken(String value) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: DatabaseStrings.googleRefreshToken, value: value);
  }

  static Future<String?> getGoogleRefreshToken() async {
    const storage = FlutterSecureStorage();
    return storage.read(key: DatabaseStrings.googleRefreshToken);
  }

  static Future<void> clear() async {
    const storage = FlutterSecureStorage();
    return storage.deleteAll();
  }
}
