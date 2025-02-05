import 'package:college_cupid/domain/models/onedrive_data.dart';
import 'package:college_cupid/services/shared_prefs.dart';
import 'package:dio/dio.dart';

class OneDriveRepository {
  static Future<void> uploadPrivateData(OneDriveData data) async {
    const uploadUrl =
        'https://graph.microsoft.com/v1.0/me/drive/special/approot:/user_keys.json:/content';

    final accessToken = await SharedPrefService.getOutlookAccessToken();

    await Dio().put(
      uploadUrl,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ),
      data: data.toJSON(),
    );
  }

  static Future<OneDriveData?> readPrivateData() async {
    const fileUrl =
        'https://graph.microsoft.com/v1.0/me/drive/special/approot:/user_keys.json:/content';

    final accessToken = await SharedPrefService.getOutlookAccessToken();

    final res = await Dio().get(fileUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ));

    final data = OneDriveData.fromJSON(res.data);
    return data;
  }

  static Future<List<String>> getMyCrushes() async {
    final data = await readPrivateData();
    if (data == null) {
      throw Exception("File missing from OneDrive!");
    }
    return data.crushEmailList;
  }

  static Future<void> addCrush(String email) async {
    var data = await readPrivateData();
    if (data == null) {
      throw Exception("File missing from OneDrive!");
    }
    if (data.crushEmailList.contains(email)) {
      throw Exception("Email already present in the list!");
    }
    data.crushEmailList.add(email);
    return uploadPrivateData(data);
  }

  static Future<void> removeCrush(int index) async {
    var data = await readPrivateData();
    if (data == null) {
      throw Exception("File missing from OneDrive!");
    }
    if (data.crushEmailList.length <= index || index < 0) {
      throw Exception("Index out of bounds!");
    }
    data.crushEmailList.removeAt(index);
    return uploadPrivateData(data);
  }

  static Future<void> uploadDHPrivateKey(String dhPrivateKey) async {
    return uploadPrivateData(OneDriveData(
      crushEmailList: [],
      diffieHellmanPrivateKey: dhPrivateKey,
    ));
  }

  static Future<String?> getDHPrivateKey() async {
    return (await readPrivateData())?.diffieHellmanPrivateKey;
  }
}
