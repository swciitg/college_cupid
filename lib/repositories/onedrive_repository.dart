import 'dart:developer';

import 'package:college_cupid/domain/models/onedrive_data.dart';
import 'package:college_cupid/services/secure_storage_service.dart';
import 'package:dio/dio.dart';

class OneDriveRepository {
  static Future<void> uploadPrivateData(OneDriveData data) async {
    final dio = Dio();
    dio.interceptors.add(AuthInterceptor(dio));

    const uploadUrl =
        'https://graph.microsoft.com/v1.0/me/drive/special/approot:/user_keys.json:/content';

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
        return Future.error(res.data);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<OneDriveData?> readPrivateData() async {
    final dio = Dio();
    dio.interceptors.add(AuthInterceptor(dio));

    const fileUrl =
        'https://graph.microsoft.com/v1.0/me/drive/special/approot:/user_keys.json:/content';

    final accessToken = await SecureStorageService.getOutlookAccessToken();

    // log("AccessToken: $accessToken");

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
        log("Onedrive Error: ${res.data}");
        return Future.error(res.data);
      }
    } on DioException catch (e) {
      log("Onedrive Error: ${e.response?.data}");
      return Future.error(e.response?.data);
    }
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

class AuthInterceptor extends Interceptor {
  final Dio dio;

  final clientID = const String.fromEnvironment("CLIENT_ID");
  final clientSecret = const String.fromEnvironment("CLIENT_SECRET");
  final tenantID = const String.fromEnvironment("TENANT_ID");

  AuthInterceptor(this.dio) {
    log(clientSecret);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
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
          cloneReq = await dio.request(opts.path,
              queryParameters: opts.queryParameters, options: options);
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

    log("Refresh Token: $refreshToken");

    try {
      final response = await dio.post(
        'https://login.microsoftonline.com/$tenantID/oauth2/v2.0/token',
        options: Options(
            headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
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
      log('Refresh Token Failed: ${e.response?.data}');
    }

    return false;
  }
}
