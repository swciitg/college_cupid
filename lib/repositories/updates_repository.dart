import 'dart:developer';
import 'package:college_cupid/domain/models/update_model.dart';
import 'package:college_cupid/domain/models/user_profile.dart'; // Needed if we map to users
import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/repositories/api_repository.dart';
import 'package:college_cupid/shared/endpoints.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:college_cupid/repositories/user_profile_repository.dart';

import 'package:college_cupid/repositories/confessions_repository.dart';

final updatesRepoProvider = Provider<UpdatesRepository>((ref) =>
    UpdatesRepositoryImpl(ref.read(apiRepositoryProvider),
        ref.read(userProfileRepoProvider), ref.read(confessionsRepoProvider)));

abstract class UpdatesRepository {
  Future<List<UpdateModel>> fetchUpdates({String? filter});
}

class UpdatesRepositoryImpl implements UpdatesRepository {
  final ApiRepository _apiRepository;
  final UserProfileRepository _userProfileRepository;
  final ConfessionsRepository _confessionsRepository;

  UpdatesRepositoryImpl(this._apiRepository, this._userProfileRepository,
      this._confessionsRepository);

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

        // Extract unique sender emails to fetch profiles
        final senderEmails = data
            .map((json) => json['senderEmail'] as String?)
            .where((email) => email != null && email.isNotEmpty)
            .toSet();

        // Fetch user profiles for these emails
        final Map<String, UserProfile> userProfileMap = {};

        // Concurrent fetching
        await Future.wait(senderEmails.map((email) async {
          if (email == null) return;
          try {
            final profileMap =
                await _userProfileRepository.getUserProfile(email);
            if (profileMap != null) {
              userProfileMap[email] = UserProfile.fromJson(profileMap);
            }
          } catch (e) {
            log('Error fetching profile for $email: $e');
          }
        }));

        // Concurrent fetching for updates logic (profiles AND confessions)
        final List<UpdateModel?> processedUpdates =
            await Future.wait(data.map((json) async {
          final senderEmail = json['senderEmail'] as String? ?? '';
          final userProfile = userProfileMap[senderEmail] ??
              UserProfile.fromEmail(
                  senderEmail.isEmpty ? 'Unknown User' : senderEmail);

          String? replyToText = json['repliedContent'];
          if (replyToText == null && json['confessionId'] != null) {
            final confessionId = json['confessionId'] as String;
            final confession = await _confessionsRepository.getConfessionById(
                confessionId, encryptedEmail);
            if (confession != null) {
              replyToText = confession.text;
            } else {
              return null;
            }
          }

          return UpdateModel(
            id: json['_id'] ?? '',
            senderUser: userProfile,
            type: UpdateType.textReply, //TODO: Update type based on update type
            headerText:
                "Replied to your confession", //TODO: Update header text based on update type
            replyText: json['replyContent'] ?? '',
            replyTo: replyToText,
            timestamp:
                DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
          );
        }));

        final allUpdates = processedUpdates.whereType<UpdateModel>().toList();

        if (filter == 'All') {
          return allUpdates;
        } else if (filter == 'Confession') {
          return allUpdates
              .where((u) =>
                  u.type == UpdateType.textReply ||
                  u.type == UpdateType.voiceReply ||
                  u.type == UpdateType.confessionReply)
              .toList();
        } else if (filter == 'Match') {
          return allUpdates.where((u) => u.type == UpdateType.match).toList();
        } else if (filter == 'Profile') {
          // Add profile updates logic here if/when available
          return [];
        }
        return allUpdates;
      }
    } catch (e) {
      log('Error fetching updates: $e');
    }
    return [];
  }
}
