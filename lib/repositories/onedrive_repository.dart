import 'dart:developer';

import 'package:college_cupid/domain/models/onedrive_data.dart';
import 'package:college_cupid/services/secure_storage_service.dart';
import 'package:college_cupid/services/shared_prefs.dart';
import 'package:dio/dio.dart';

class OneDriveRepository {
  static _log(String message) {
    log(message, name: "OneDriveRepository");
  }

  static Future<String> _getUserId() async {
    try {
      final profile = await SharedPrefService.getMyProfile();
      final userId = profile['_id'] ?? profile['id'];
      if (userId == null || userId.toString().isEmpty) {
        throw Exception('User ID not found in profile');
      }
      return userId.toString();
    } catch (e) {
      _log('Error getting user ID: $e');
      rethrow;
    }
  }

  static Future<String> _getFileUrl() async {
    final userId = await _getUserId();
    final fileUrl =
        'https://graph.microsoft.com/v1.0/me/drive/special/approot:/${userId}_user_keys.json:/content';
    return fileUrl;
  }

  static Future<void> uploadPrivateData(OneDriveData data) async {
    final dio = Dio();
    dio.interceptors.add(AuthInterceptor(dio));

    final uploadUrl = await _getFileUrl();

    final accessToken = await SecureStorageService.getOutlookAccessToken();

    try {
      final res = await dio.put(
        uploadUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
        data: data.toJSON(),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return;
      } else {
        _log('Upload failed with status: ${res.statusCode}');
        return Future.error(res.data);
      }
    } catch (e) {
      _log('Upload error: $e');
      return Future.error(e);
    }
  }

  static Future<OneDriveData?> readPrivateData() async {
    final dio = Dio();
    dio.interceptors.add(AuthInterceptor(dio));

    final fileUrl = await _getFileUrl();

    final accessToken = await SecureStorageService.getOutlookAccessToken();

    try {
      final res = await dio.get(
        fileUrl,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = OneDriveData.fromJSON(res.data);
        return data;
      } else {
        _log("Onedrive Error: ${res.data}");
        return Future.error(res.data);
      }
    } on DioException catch (e) {
      _log("Onedrive Error: ${e.response?.data}");
      return Future.error(e.response?.data);
    }
  }

  static Future<List<String>> getMyCrushes() async {
    final data = await readPrivateData();
    if (data == null) {
      _log('Error: File missing from OneDrive');
      throw Exception("File missing from OneDrive!");
    }
    return data.crushEmailList;
  }

  static Future<void> addCrush(String email) async {
    var data = await readPrivateData();
    if (data == null) {
      _log('Error: File missing from OneDrive');
      throw Exception("File missing from OneDrive!");
    }
    if (data.crushEmailList.contains(email)) {
      _log('Error: Email already present in the list');
      throw Exception("Email already present in the list!");
    }
    data.crushEmailList.add(email);
    return uploadPrivateData(data);
  }

  static Future<void> removeCrush(String email) async {
    var data = await readPrivateData();
    if (data == null) {
      _log('Error: File missing from OneDrive');
      throw Exception("File missing from OneDrive!");
    }
    if (!data.crushEmailList.contains(email)) {
      _log('Error: Email not found in crush list');
      throw Exception("Email not found in crush list!");
    }
    data.crushEmailList.remove(email);
    return uploadPrivateData(data);
  }

  static Future<void> uploadDHPrivateKey(String dhPrivateKey) async {
    return uploadPrivateData(OneDriveData(
      crushEmailList: [],
      diffieHellmanPrivateKey: dhPrivateKey,
    ));
  }

  static Future<String?> getDHPrivateKey() async {
    final key = (await readPrivateData())?.diffieHellmanPrivateKey;
    return key;
  }
}

class AuthInterceptor extends Interceptor {
  final Dio dio;

  final clientID = const String.fromEnvironment("CLIENT_ID");
  final clientSecret = const String.fromEnvironment("CLIENT_SECRET");
  final tenantID = const String.fromEnvironment("TENANT_ID");

  AuthInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Get the access token from secure storage
    String? accessToken = await SecureStorageService.getOutlookAccessToken();

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      bool refreshed = await _refreshToken();

      if (refreshed) {
        late Response cloneReq;
        final opts = err.requestOptions;
        final options = Options(method: opts.method, headers: opts.headers);
        opts.headers['Authorization'] =
            'Bearer ${await SecureStorageService.getOutlookAccessToken()}';
        if (opts.method == "GET") {
          cloneReq =
              await dio.request(opts.path, queryParameters: opts.queryParameters, options: options);
        } else {
          cloneReq = await dio.request(
            opts.path,
            queryParameters: opts.queryParameters,
            data: opts.data,
            options: options,
          );
        }
        return handler.resolve(cloneReq);
      }
    }

    super.onError(err, handler);
  }

  Future<bool> _refreshToken() async {
    String? refreshToken = await SecureStorageService.getOutlookRefreshToken();

    if (refreshToken == null) {
      return false;
    }

    try {
      final response = await dio.post(
        'https://login.microsoftonline.com/$tenantID/oauth2/v2.0/token',
        options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
        data: {
          'client_id': clientID,
          'scope': 'User.Read Files.ReadWrite.AppFolder offline_access',
          'refresh_token': refreshToken,
          'grant_type': 'refresh_token',
          'client_secret': clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];

        // Store new tokens
        await SecureStorageService.setOutlookAccessToken(newAccessToken);
        await SecureStorageService.setOutlookRefreshToken(newRefreshToken);

        return true;
      }
    } on DioException catch (e) {
      log('Refresh Token Failed: ${e.response?.data}', name: 'OneDriveRepository');
    }

    return false;
  }
}
