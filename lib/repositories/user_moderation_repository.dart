// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/repositories/api_repository.dart';
import 'package:college_cupid/shared/endpoints.dart';
import 'package:dio/dio.dart';

class _UserModerationRepository extends ApiRepository {
  _UserModerationRepository() : super();

  Future<void> reportAndBlockUser(String userEmail, String reasonForReporting) async {
    try {
      Response res = await dio.post(Endpoints.reportUser,
          data: jsonEncode({'reportedEmail': userEmail, 'reasonForReporting': reasonForReporting}));

      if (res.statusCode == 200) {
        return;
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<List<String>> getBlockedUsers() async {
    try {
      Response res = await dio.get(Endpoints.getBlockedUsers);
      if (res.statusCode == 200) {
        List blockedUsers = res.data['blockedUsers'];
        return blockedUsers.map((user) => user.toString()).toList();
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<bool> unblockUser(int index) async {
    try {
      Response res = await dio.delete(
        Endpoints.unblockUser,
        queryParameters: {'index': index},
      );
      if (res.statusCode == 200) {
        showSnackBar(res.data['message']);
        return res.data['success'] as bool;
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (err) {
      return Future.error(err.toString());
    }
  }
}

final UserModerationRepository = _UserModerationRepository();
