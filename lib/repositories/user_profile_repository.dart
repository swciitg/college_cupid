import 'dart:developer';
import 'dart:io';

import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/repositories/api_repository.dart';
import 'package:college_cupid/shared/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';

final userProfileRepoProvider = Provider<UserProfileRepository>((ref) => UserProfileRepository());

class UserProfileRepository extends ApiRepository {
  UserProfileRepository() : super();

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
      log("User profile");
      for (var e in formData.fields) {
        log("${e.key} : ${e.value}");
      }
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
      return res.data['userProfile'];
    } catch (error) {
      debugPrint("Error getting User Profile: $error");
      return null;
    }
  }

  Future<List<UserProfile>> getPaginatedUsers(
      int pageNumber, Map<String, dynamic>? filterQuery) async {
    for (var key in filterQuery!.keys.toList()) {
      if (filterQuery[key] == null) filterQuery.remove(key);
    }
    try {
      Response res = await dio.get('${Endpoints.getPaginatedUserProfiles}/$pageNumber',
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
}
