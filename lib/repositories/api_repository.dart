import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/services/backend_helper.dart';
import 'package:college_cupid/shared/endpoints.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiRepository {
  final _dio = Dio(BaseOptions(
      baseUrl: Endpoints.apiUrl,
      connectTimeout: const Duration(seconds: 35),
      receiveTimeout: const Duration(seconds: 15),
      headers: Endpoints.getHeader()));

  final _dio2 = Dio(BaseOptions(
      baseUrl: Endpoints.apiUrl,
      connectTimeout: const Duration(seconds: 35),
      receiveTimeout: const Duration(seconds: 15),
      headers: Endpoints.getMultipartHeader()));

  final _authFreeDio = Dio(BaseOptions(
      baseUrl: Endpoints.apiUrl,
      connectTimeout: const Duration(seconds: 35),
      receiveTimeout: const Duration(seconds: 15),
      headers: Endpoints.getHeader()));

  Dio get dio => _dio;

  Dio get dio2 => _dio2;

  @protected
  Dio get authFreeDio => _authFreeDio;

  ApiRepository() {
    _authFreeDio.interceptors
        .add(InterceptorsWrapper(onError: (error, handler) async {
      var response = error.response;

      if (response != null) {
        debugPrint(
            'AuthFree API Error: ${response.statusCode} - ${response.statusMessage}');
        debugPrint('URL: ${response.requestOptions.uri}');
        debugPrint('Data: ${response.data}');
        showSnackBar("Some error occurred, please try again later!");
      }
      return handler.next(error);
    }));
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      options.headers["Authorization"] = "Bearer ${LoginStore.accessToken}";
      debugPrint("Header: ${options.headers}");
      handler.next(options);
    }, onError: (error, handler) async {
      var response = error.response;
      if (response != null && response.statusCode == 401) {
        if (LoginStore.accessToken!.isEmpty) {
          showSnackBar("Login to continue!!");
        } else {
          bool couldRegenerate = await BackendHelper().regenerateAccessToken();
          if (couldRegenerate) {
            debugPrint('RETRYING REQUEST');
            return handler
                .resolve(await BackendHelper().retryRequest(response));
          } else {
            await LoginStore.logout();
            showSnackBar("Your session has expired!! Login again.");
          }
        }
      } else if (response != null) {
        debugPrint(
            'API Error: ${response.statusCode} - ${response.statusMessage}');
        debugPrint('URL: ${response.requestOptions.uri}');
        debugPrint('Data: ${response.data}');
        showSnackBar("Some error occurred, please try again later!");
      }
      return handler.next(error);
    }));
  }
}

final apiRepositoryProvider = Provider<ApiRepository>((ref) => ApiRepository());
