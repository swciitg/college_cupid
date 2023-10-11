import 'package:college_cupid/models/user.dart';
import 'package:dio/dio.dart';
import '../globals/endpoints.dart';
import './auth_helpers.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

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
      } else if (response != null && response.statusCode == 400) {}
      // admin user with expired tokens
      return handler.next(error);
    }));
  }

  Future<void> signIn(File image, UserModel user) async {
    String fileName = image.path.split('/').last;
    final userMap = user.toJson();
    userMap['dp'] = await MultipartFile.fromFile(
      image.path,
      filename: fileName,
      contentType: MediaType('image', 'png'),
    );
    FormData formData = FormData.fromMap(userMap);

    try {
      print('sending request');
      Response res =
          await dio.post('${Endpoints.baseUrl}/user/signin', data: formData);

      if (res.statusCode == 200) {
        print('Image uploaded successfully');
        String access = res.data['accessToken'];
        String refresh = res.data['refreshToken'];
        String gval = res.data['gValue'];
        print(access);
        print(gval);
        print(refresh);
        await AuthUserHelpers.setAccessToken(access);
        await AuthUserHelpers.setRefreshToken(refresh);
        await AuthUserHelpers.setGValue(gval);
        // return res.data['imageUrl'].toString();
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
