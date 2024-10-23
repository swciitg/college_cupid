import 'dart:convert';
import 'package:college_cupid/domain/models/personal_info.dart';
import 'package:college_cupid/repositories/api_repository.dart';
import 'package:college_cupid/shared/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personalInfoRepoProvider =
    Provider<PersonalInfoRepository>((ref) => PersonalInfoRepository());

class PersonalInfoRepository extends ApiRepository {
  PersonalInfoRepository() : super();

  Future<void> postPersonalInfo(PersonalInfo myInfo) async {
    try {
      await dio.post(Endpoints.postPersonalInfo, data: jsonEncode(myInfo));
    } catch (e) {
      debugPrint("Error Posting Personal Info: $e");
      return;
    }
  }

  Future<Map<String, dynamic>?> getPersonalInfo() async {
    try {
      Response res = await dio.get(Endpoints.getPersonalInfo);
      return res.data['personalInfo'];
    } catch (e) {
      debugPrint("Error getting Personal Info: $e");
      return null;
    }
  }
}
