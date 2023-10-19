import 'dart:convert';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/models/personal_info.dart';
import 'package:college_cupid/models/user_info.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:dio/dio.dart';
import '../globals/endpoints.dart';
import './auth_helpers.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class APIService {
  final dio = Dio(BaseOptions(
      baseUrl: Endpoints.baseUrl,
      connectTimeout: const Duration(seconds: 35),
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
          showSnackBar("Login to continue!!");
        } else {
          bool couldRegenerate =
              await AuthUserHelpers().regenerateAccessToken();
          if (couldRegenerate) {
            // retry
            return handler
                .resolve(await AuthUserHelpers().retryRequest(response));
          } else {
            showSnackBar("Your session has expired!! Login again.");
          }
        }
      } else if (response != null && response.statusCode == 403) {
        //TODO: Resolve authorization errors
        //showSnackBar("Access not allowed in guest mode");
      } else if (response != null && response.statusCode == 400) {}
      // admin user with expired tokens
      return handler.next(error);
    }));
  }

  Future<String> postMyInfo(File? image, PersonalInfo myInfo) async {
    final userMap = myInfo.toJson();
    if (image != null) {
      String fileName = image.path.split('/').last;
      userMap['dp'] = await MultipartFile.fromFile(
        image.path,
        filename: fileName,
        contentType: MediaType('image', 'png'),
      );
    }
    FormData formData = FormData.fromMap(userMap);

    try {
      print('sending request');
      Response res = await dio.post(Endpoints.baseUrl + Endpoints.postMyInfo,
          data: formData);

      if (res.statusCode == 200) {
        return res.data['profilePicUrl'] ?? '';
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<List<UserInfo>> getAllOtherUsers() async {
    try {
      Response res = await dio.get(Endpoints.baseUrl + Endpoints.getAllUsers);
      if (res.statusCode == 200) {
        final users = res.data['users'];
        List<UserInfo> usersInfo = [];
        for (int i = users.length - 1; i >= 0; i--) {
          List<String> interests = [];
          for (int j = 0; j < (users[i]['interests'] as List).length; j++) {
            interests.add(users[i]['interests'][j].toString());
          }

          if (users[i]['email'].toString() == LoginStore.email) continue;
          usersInfo.add(UserInfo(
              name: users[i]['name'] as String,
              profilePicUrl: users[i]['profilePicUrl'] as String,
              gender: users[i]['gender'] as String,
              email: users[i]['email'] as String,
              bio: users[i]['bio'] as String,
              yearOfStudy: users[i]['yearOfStudy'] as String,
              program: users[i]['program'] as String,
              publicKey: users[i]['publicKey'] as String,
              interests: interests));
        }
        return usersInfo;
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (err) {
      return Future.error(err.toString());
    }
  }

  Future<Map<String, dynamic>?> getPersonalInfo() async {
    try {
      Response res =
          await dio.get(Endpoints.baseUrl + Endpoints.getPersonalInfo);
      if (res.statusCode == 200) {
        return res.data['personalInfo'];
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (error) {
      return Future.error(error.toString());
    }
  }

  Future<void> addCrush(String sharedSecret, String encryptedCrushEmail) async {
    try {
      Response res = await dio.put(Endpoints.baseUrl + Endpoints.addCrush,
          data: jsonEncode({
            'sharedSecret': sharedSecret,
            'encryptedCrushEmail': encryptedCrushEmail
          }));

      if (res.statusCode == 200) {
        return;
      } else {
        Future.error(res.statusMessage.toString());
      }
    } catch (err) {
      return Future.error(err.toString());
    }
  }
}
