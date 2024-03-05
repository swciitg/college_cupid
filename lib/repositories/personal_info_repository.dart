import 'dart:convert';

import 'package:college_cupid/domain/models/personal_info.dart';
import 'package:college_cupid/repositories/api_repository.dart';
import 'package:college_cupid/shared/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personalInfoRepoProvider =
    Provider<PersonalInfoRepository>((ref) => PersonalInfoRepository());

class PersonalInfoRepository extends ApiRepository {
  PersonalInfoRepository() : super();

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
}
