import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/services/backend_helper.dart';
import 'package:college_cupid/shared/endpoints.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ApiRepository {
  final _dio = Dio(BaseOptions(
      baseUrl: Endpoints.apiUrl,
      connectTimeout: const Duration(seconds: 35),
      receiveTimeout: const Duration(seconds: 15),
      headers: Endpoints.getHeader()));

  final _authFreeDio = Dio(BaseOptions(
      baseUrl: Endpoints.apiUrl,
      connectTimeout: const Duration(seconds: 35),
      receiveTimeout: const Duration(seconds: 15),
      headers: Endpoints.getHeader()));

  @protected
  Dio get dio => _dio;

  @protected
  Dio get authFreeDio => _authFreeDio;

  ApiRepository() {
    _authFreeDio.interceptors
        .add(InterceptorsWrapper(onError: (error, handler) async {
      var response = error.response;

      if (response != null) {
        showSnackBar("Some error occurred, please try again later!");
      }
      return handler.next(error);
    }));
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      options.headers["Authorization"] = "Bearer ${LoginStore.accessToken}";
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
        showSnackBar("Some error occurred, please try again later!");
      }
      return handler.next(error);
    }));
  }
}
