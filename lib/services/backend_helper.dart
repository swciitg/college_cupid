import 'dart:developer';

import 'package:college_cupid/services/shared_prefs.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter/material.dart';
import '../shared/database_strings.dart';
import '../shared/endpoints.dart';
import 'package:dio/dio.dart';

class BackendHelper {
  Future<Response<dynamic>> retryRequest(Response response) async {
    debugPrint('RETRYING REQUEST');
    RequestOptions requestOptions = response.requestOptions;
    response.requestOptions.headers[DatabaseStrings.authorization] =
        "Bearer ${LoginStore.accessToken}";
    try {
      final options = Options(method: requestOptions.method, headers: requestOptions.headers);
      Dio retryDio = Dio(BaseOptions(
          baseUrl: Endpoints.baseUrl,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          headers: {'Security-Key': Endpoints.apiSecurityKey}));
      if (requestOptions.method == "GET") {
        return retryDio.request(requestOptions.path,
            queryParameters: requestOptions.queryParameters, options: options);
      } else {
        return retryDio.request(requestOptions.path,
            queryParameters: requestOptions.queryParameters,
            data: requestOptions.data,
            options: options);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> regenerateAccessToken() async {
    debugPrint('REGENERATING ACCESS TOKEN');
    String refreshToken = LoginStore.refreshToken!;
    try {
      Dio regenDio = Dio(
        BaseOptions(
          baseUrl: Endpoints.baseUrl,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      Response resp = await regenDio.post(Endpoints.apiUrl + Endpoints.regenerateToken,
          options: Options(headers: {"authorization": "Bearer $refreshToken"}));
      var data = resp.data!;
      await SharedPrefs.setAccessToken(data[DatabaseStrings.accessToken]);
      await LoginStore.initializeTokens();
      return true;
    } catch (err) {
      log("Error in regenerating token: $err");
      return false;
    }
  }
}
