import 'dart:developer';
import 'package:college_cupid/domain/models/update_model.dart';
import 'package:college_cupid/domain/models/user_profile.dart'; // Needed if we map to users
import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/repositories/api_repository.dart';
import 'package:college_cupid/shared/endpoints.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updatesRepoProvider = Provider<UpdatesRepository>(
    (ref) => UpdatesRepositoryImpl(ref.read(apiRepositoryProvider)));

abstract class UpdatesRepository {
  Future<List<UpdateModel>> fetchUpdates({String? filter});
}

class UpdatesRepositoryImpl implements UpdatesRepository {
  final ApiRepository _apiRepository;

  UpdatesRepositoryImpl(this._apiRepository);

  @override
  Future<List<UpdateModel>> fetchUpdates({String? filter}) async {
    try {
      final encryptedEmail =
          Encryption.encryptEmail(LoginStore.email!, Endpoints.apiSecurityKey);
      final response = await _apiRepository.dio.post(
        Endpoints.getUpdates,
        data: {'encryptedEmail': encryptedEmail},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];

        // Map Reply objects to UpdateModel
        // Backend Reply: { senderEmail, replyContent, receiverEmail, confessionId, createdAt, ... }
        // Frontend UpdateModel: { id, senderUser, type, headerText, contentPayload, ... }

        return data.map((json) {
          return UpdateModel(
            id: json['_id'] ?? '',
            senderUser: UserProfile.fromEmail(
                json['senderEmail'] ?? 'Unknown'), // Placeholder user
            type: UpdateType.textReply, // Assuming all replies are text for now
            headerText: "Replied to you",
            contentPayload: json['replyContent'],
            timestamp: DateTime.parse(json['createdAt']),
          );
        }).toList();
      }
    } catch (e) {
      log('Error fetching updates: $e');
    }
    return [];
  }
}
