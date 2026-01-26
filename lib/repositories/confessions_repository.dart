import 'package:college_cupid/domain/models/confession.dart';
import 'dart:developer';
import 'package:college_cupid/repositories/api_repository.dart';
import 'package:college_cupid/shared/endpoints.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final confessionsRepoProvider = Provider<ConfessionsRepository>(
    (ref) => ConfessionsRepositoryImpl(ref.read(apiRepositoryProvider)));

abstract class ConfessionsRepository {
  Future<List<Confession>> getConfessions(
      {ConfessionCategory? category, int page = 0});
  Future<List<Confession>> getMyConfessions(String encryptedEmail);
  Future<bool> postConfession(
      String text, String category, String encryptedEmail);
  Future<bool> reactToConfession(String id, String reaction);
  Future<bool> replyToConfession(String confessionId, String content);
  Future<bool> deleteConfession(String id, String encryptedEmail);
  Future<bool> reportConfession(String id, ConfessionReportCategory category);
  Future<bool> removeReaction(String id);
}

class ConfessionsRepositoryImpl implements ConfessionsRepository {
  final ApiRepository _apiRepository;

  ConfessionsRepositoryImpl(this._apiRepository);

  @override
  Future<List<Confession>> getConfessions(
      {ConfessionCategory? category, int page = 0}) async {
    try {
      final queryParams = <String, dynamic>{'page': page};
      if (category != null) {
        queryParams['type'] = category.name;
      }

      final response = await _apiRepository.dio.get(
        Endpoints.getConfessions,
        queryParameters: queryParams,
      );

      debugPrint(
          'DEBUG REPO: getConfessions Response status: ${response.statusCode}');
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) {
          // Robust JSON parsing to avoid crashes on enum mismatch
          return Confession.fromJson(json);
        }).toList();
      } else {
        debugPrint(
            'DEBUG REPO: getConfessions Response data: ${response.data}');
      }
    } catch (e) {
      log('Error getting confessions: $e');
    }
    return [];
  }

  @override
  Future<List<Confession>> getMyConfessions(String encryptedEmail) async {
    try {
      final response = await _apiRepository.dio.post(
        Endpoints.getMyConfessions,
        data: {'encryptedEmail': encryptedEmail},
      );

      debugPrint(
          'DEBUG REPO: getMyConfessions Response status: ${response.statusCode}');
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Confession.fromJson(json)).toList();
      } else {
        debugPrint(
            'DEBUG REPO: getMyConfessions Response data: ${response.data}');
      }
    } catch (e) {
      log('Error getting my confessions: $e');
    }
    return [];
  }

  @override
  Future<bool> postConfession(
      String text, String category, String encryptedEmail) async {
    try {
      debugPrint('DEBUG REPO: Posting confession...');
      debugPrint(
          'DEBUG REPO: Payload: email=$encryptedEmail, text=$text, type=$category');

      final response = await _apiRepository.dio.post(
        Endpoints.postConfession,
        data: {
          'encryptedEmail': encryptedEmail,
          'text': text,
          'typeOfConfession': category,
        },
      );

      debugPrint('DEBUG REPO: Response status: ${response.statusCode}');
      debugPrint('DEBUG REPO: Response data: ${response.data}');

      return response.statusCode == 200 && response.data['success'] == true;
    } catch (e) {
      debugPrint('DEBUG REPO: Error posting confession: $e');
      if (e is Error) {
        debugPrint('DEBUG REPO: StackTrace: ${e.stackTrace}');
      }
      return false;
    }
  }

  @override
  Future<bool> reactToConfession(String id, String reaction) async {
    try {
      final response = await _apiRepository.dio.put(
        '${Endpoints.reactToConfession}/$id',
        data: {'reaction': reaction},
      );
      debugPrint(
          'DEBUG REPO: reactToConfession Response status: ${response.statusCode}');
      debugPrint(
          'DEBUG REPO: reactToConfession Response data: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        if (LoginStore.userId == null || LoginStore.userId!.isEmpty) {
          debugPrint('DEBUG REPO: Attempting to capture userId from response');
          final data = response.data['data']['reactions'];
          final userId = data['user'];
          if (userId != null) {
            LoginStore.userId = userId;
            debugPrint('DEBUG REPO: Captured userId: $userId');
          }
        }
        return true;
      }
      return false;
    } catch (e) {
      log('Error reacting to confession: $e');
      return false;
    }
  }

  @override
  Future<bool> replyToConfession(String confessionId, String content) async {
    try {
      final response = await _apiRepository.dio.post(
        Endpoints.postReply,
        data: {
          'isConfession': true,
          'confessionId': confessionId,
          'replyContent': content,
        },
      );
      debugPrint(
          'DEBUG REPO: replyToConfession Response status: ${response.statusCode}');
      debugPrint(
          'DEBUG REPO: replyToConfession Response data: ${response.data}');
      return response.statusCode == 200 && response.data['success'] == true;
    } catch (e) {
      log('Error replying to confession: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteConfession(String id, String encryptedEmail) async {
    try {
      final response = await _apiRepository.dio.delete(
        '${Endpoints.deleteConfession}/$id',
        data: {'encryptedEmail': encryptedEmail},
      );
      debugPrint(
          'DEBUG REPO: deleteConfession Response status: ${response.statusCode}');
      debugPrint(
          'DEBUG REPO: deleteConfession Response data: ${response.data}');
      return response.statusCode == 200 && response.data['success'] == true;
    } catch (e) {
      debugPrint('DEBUG REPO: Error deleting confession: $e');
      return false;
    }
  }

  @override
  Future<bool> reportConfession(
      String id, ConfessionReportCategory category) async {
    try {
      final response = await _apiRepository.dio.put(
        '${Endpoints.reportConfession}/$id',
        data: {'category': category.name},
      );
      debugPrint(
          'DEBUG REPO: reportConfession Response status: ${response.statusCode}');
      debugPrint(
          'DEBUG REPO: reportConfession Response data: ${response.data}');
      return response.statusCode == 200 && response.data['success'] == true;
    } catch (e) {
      debugPrint('DEBUG REPO: Error reporting confession: $e');
      return false;
    }
  }

  @override
  Future<bool> removeReaction(String id) async {
    try {
      final response = await _apiRepository.dio.delete(
        '${Endpoints.reactToConfession}/$id',
      );
      debugPrint(
          'DEBUG REPO: removeReaction Response status: ${response.statusCode}');
      debugPrint('DEBUG REPO: removeReaction Response data: ${response.data}');
      return response.statusCode == 200 && response.data['success'] == true;
    } catch (e) {
      debugPrint('DEBUG REPO: Error removing reaction: $e');
      return false;
    }
  }
}
