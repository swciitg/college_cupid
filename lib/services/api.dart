import 'dart:convert';
import '../functions/snackbar.dart';
import '../models/personal_info.dart';
import '../models/user_profile.dart';
import '../stores/login_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../shared/endpoints.dart';
import './backend_helper.dart';
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
            // retry
            return handler
                .resolve(await BackendHelper().retryRequest(response));
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

  Future<void> postPersonalInfo(PersonalInfo myInfo) async {
    try {
      debugPrint('Posting personal info');
      Response res =
          await dio.post(Endpoints.postPersonalInfo, data: jsonEncode(myInfo));

      if (res.statusCode == 200) {
        return;
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (e) {
      return Future.error(e.toString());
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

  Future<List> getCrush() async {
    try {
      Response res = await dio.get(Endpoints.getCrush);
      if (res.statusCode == 200) {
        return res.data['encryptedCrushes'];
      } else {
        print('Request Failed with status: ${res.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  Future<String> postUserProfile(File? image, UserProfile userProfile) async {
    final userProfileMap = userProfile.toJson();
    if (image != null) {
      String fileName = image.path.split('/').last;
      userProfileMap['dp'] = await MultipartFile.fromFile(
        image.path,
        filename: fileName,
        contentType: MediaType('image', 'png'),
      );
    }
    FormData formData = FormData.fromMap(userProfileMap);

    try {
      debugPrint('Posting user profile');
      Response res = await dio.post(Endpoints.postUserProfile, data: formData);

      debugPrint(res.data.toString());

      if (res.statusCode == 200) {
        return res.data['profilePicUrl'] ?? '';
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (error) {
      return Future.error(error.toString());
    }
  }

  Future<String> updateUserProfile(File? image, UserProfile userProfile) async {
    final userProfileMap = userProfile.toJson();
    if (image != null) {
      print("image path: ${image.path}");
      String fileName = image.path.split('/').last;
      userProfileMap['dp'] = await MultipartFile.fromFile(
        image.path,
        filename: fileName,
        contentType: MediaType('image', 'png'),
      );
    }
    FormData formData = FormData.fromMap(userProfileMap);

    try {
      Response res = await dio.put(Endpoints.updateUserProfile, data: formData);

      debugPrint(res.data.toString());

      if (res.statusCode == 200) {
        print("profilePicUrl : ${res.data['profilePicUrl']}");
        return res.data['profilePicUrl'] ?? '';
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (error) {
      return Future.error(error.toString());
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(String email) async {
    try {
      Response res = await dio.get('${Endpoints.getUserProfile}/$email');
      if (res.statusCode == 200) {
        return res.data['userProfile'];
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (error) {
      return Future.error(error.toString());
    }
  }

  Future<List<UserProfile>> getAllOtherUsers() async {
    try {
      Response res = await dio.get(Endpoints.getAllUserProfiles);
      if (res.statusCode == 200) {
        final users = res.data['users'];
        List<UserProfile> userProfiles = [];
        for (int i = users.length - 1; i >= 0; i--) {
          List<String> interests = [];
          for (int j = 0; j < (users[i]['interests'] as List).length; j++) {
            interests.add(users[i]['interests'][j].toString());
          }
          if (users[i]['email'].toString() == LoginStore.email) continue;
          userProfiles.add(UserProfile.fromJson(users[i]));
        }
        return userProfiles;
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (err) {
      return Future.error(err.toString());
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
