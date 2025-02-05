import 'dart:convert';

import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/repositories/api_repository.dart';
import 'package:college_cupid/shared/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final crushesRepoProvider =
    Provider<CrushesRepository>((ref) => CrushesRepository());

class CrushesRepository extends ApiRepository {
  CrushesRepository() : super();

  Future<void> increaseCrushesCount(String email) async {
    try {
      Response res = await authFreeDio.put(Endpoints.increaseCrushesCount,
          queryParameters: {'crushEmail': email});
      if (res.statusCode == 200) {
        return;
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (err) {
      return Future.error(err.toString());
    }
  }

  Future<void> decreaseCrushesCount(String email) async {
    try {
      Response res = await authFreeDio.put(Endpoints.decreaseCrushesCount,
          queryParameters: {'crushEmail': email});
      if (res.statusCode == 200) {
        return;
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (err) {
      return Future.error(err.toString());
    }
  }

  Future<bool> addCrush(String sharedSecret) async {
    try {
      Response res = await dio.put(Endpoints.addCrush,
          data: jsonEncode({'sharedSecret': sharedSecret}));

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

  Future<int> getCrushesCount() async {
    try {
      Response res = await dio.get(Endpoints.getCrushesCount);
      if (res.statusCode == 200) {
        return res.data['crushesCount'];
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (err) {
      return Future.error(err.toString());
    }
  }

  Future<bool> removeCrush(int index) async {
    try {
      Response res = await dio.delete(
        Endpoints.removeCrush,
        queryParameters: {'index': index},
      );
      if (res.statusCode == 200) {
        if (res.data['success'] == false) showSnackBar(res.data['message']);
        return res.data['success'];
      } else {
        return Future.error(res.statusMessage.toString());
      }
    } catch (err) {
      return Future.error(err.toString());
    }
  }
}
