import 'package:college_cupid/repositories/api_repository.dart';
import 'package:college_cupid/shared/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final matchesRepoProvider =
    Provider<MatchesRepository>((ref) => MatchesRepository());

class MatchesRepository extends ApiRepository {
  MatchesRepository() : super();

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
}
