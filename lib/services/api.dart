import 'dart:convert';
import '../functions/snackbar.dart';
import '../models/personal_info.dart';
import '../models/user_profile.dart';
import '../stores/login_store.dart';
import 'package:dio/dio.dart';
import '../shared/endpoints.dart';
import './backend_helper.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class APIService {
  final dio = Dio(BaseOptions(
      baseUrl: Endpoints.apiUrl,
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
      } else if (response != null) {
        showSnackBar("Some error occurred, please try again later!");
      }
      return handler.next(error);
    }));
  }

  Future<void> postPersonalInfo(PersonalInfo myInfo) async {
    try {
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
      Response res = await dio.get(Endpoints.getPersonalInfo);
      if (res.statusCode == 200) {
        return res.data['personalInfo'];
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (error) {
      return Future.error(error.toString());
    }
  }

  Future<List> getCrushes() async {
    try {
      Response res = await dio.get(Endpoints.getCrush);
      if (res.statusCode == 200) {
        return res.data['encryptedCrushes'];
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<List> getMatches() async {
    try {
      Response res = await dio.get(Endpoints.getMatch);
      if (res.statusCode == 200) {
        return res.data['matches'];
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (e) {
      return Future.error(e.toString());
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
      Response res = await dio.post(Endpoints.postUserProfile, data: formData);

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
      String fileName = image.path.split('/').last;
      userProfileMap['dp'] = await MultipartFile.fromFile(
        image.path,
        filename: fileName,
        contentType: MediaType('image', 'png'),
      );
    }
    userProfileMap.remove('profilePicUrl');
    FormData formData = FormData.fromMap(userProfileMap);
    try {
      Response res = await dio.put(Endpoints.updateUserProfile, data: formData);

      if (res.statusCode == 200) {
        return res.data['profilePicUrl'];
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

  Future<List<UserProfile>> getPaginatedUsers(
      int pageNumber, Map<String, dynamic>? filterQuery) async {
    for (var key in filterQuery!.keys.toList()) {
      if (filterQuery[key] == null) filterQuery.remove(key);
    }
    try {
      Response res = await dio.get(
          '${Endpoints.getPaginatedUserProfiles}/$pageNumber',
          queryParameters: filterQuery);
      if (res.statusCode == 200) {
        final users = res.data['users'];
        List<UserProfile> userProfiles = [];
        users.forEach((user) {
          userProfiles.add(UserProfile.fromJson(user));
        });
        return userProfiles;
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (err) {
      return Future.error(err.toString());
    }
  }

  Future<void> removeCrush(int index) async {
    try {
      Response res = await dio.delete(
        Endpoints.baseUrl + Endpoints.removeCrush,
        queryParameters: {'index': index},
      );
      if (res.statusCode == 200) {
        return;
      } else {
        Future.error(res.statusMessage.toString());
      }
    } catch (err) {
      return Future.error(err.toString());
    }
  }

  Future<void> addCrush(String sharedSecret, String encryptedCrushEmail) async {
    try {
      Response res = await dio.put(Endpoints.addCrush,
          data: jsonEncode({
            'sharedSecret': sharedSecret,
            'encryptedCrushEmail': encryptedCrushEmail
          }));

      if (res.statusCode == 200) {
        showSnackBar(res.data['message']);
        return;
      } else {
        Future.error(res.statusMessage.toString());
      }
    } catch (err) {
      return Future.error(err.toString());
    }
  }
}
