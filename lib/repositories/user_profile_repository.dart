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

  Future<String> postUserProfileImage(File? image, {Function(double)? onSendProgress}) async {
    try {
      final formData = FormData.fromMap({
        'dp': await MultipartFile.fromFile(
          image!.path,
          filename: image.path.split('/').last,
          contentType: MediaType('image', 'png'),
        ),
      });
      Response res = await dio.post(
        Endpoints.postProfileImage,
        data: formData,
        onSendProgress: (sent, total) {
          if (onSendProgress != null) {
            onSendProgress(sent / total);
          }
        },
      );
      if (res.statusCode == 200) {
        return res.data['imageUrl'] ?? '';
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteProfileImage(String imageId) async {
    try {
      final url = '${Endpoints.deleteProfileImage}/$imageId';
      await dio.delete(url);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> postUserProfile(UserProfile userProfile) async {
    final userProfileMap = userProfile.toJson();

    try {
      log("User profile");
      await dio.post(Endpoints.postUserProfile, data: userProfileMap);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateUserProfile(UserProfile userProfile) async {
    final userProfileMap = userProfile.toJson();
    try {
      await dio.put(Endpoints.updateUserProfile, data: userProfileMap);
    } catch (error) {
      rethrow;
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
