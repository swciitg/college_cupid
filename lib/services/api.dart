import 'package:dio/dio.dart';
import '../globals/endpoints.dart';
import './auth_helpers.dart';

class APIService {
  final dio = Dio(BaseOptions(
      baseUrl: Endpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: Endpoints.getHeader()));

  APIService() {
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      options.headers["Authorization"] =
      "Bearer ${await AuthUserHelpers.getAccessToken()}";
      handler.next(options);
    }, onError: (error, handler) async {
      var response = error.response;
      if (response != null && response.statusCode == 401) {
        if ((await AuthUserHelpers.getAccessToken()).isEmpty) {
          //showSnackBar("Login to continue!!");
        } else {
          bool couldRegenerate =
          await AuthUserHelpers().regenerateAccessToken();
          if (couldRegenerate) {
            // retry
            return handler
                .resolve(await AuthUserHelpers().retryRequest(response));
          } else {
            //showSnackBar("Your session has expired!! Login again.");
          }
        }
      } else if (response != null && response.statusCode == 403) {
        //showSnackBar("Access not allowed in guest mode");
      } else if (response != null && response.statusCode == 400) {
      }
      // admin user with expired tokens
      return handler.next(error);
    }));
  }
}