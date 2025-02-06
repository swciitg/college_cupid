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

  static Future<void> clear() async {
    const storage = FlutterSecureStorage();
    return storage.deleteAll();
  }
}
