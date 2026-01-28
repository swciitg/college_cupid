import 'dart:developer';
import 'package:flutter/foundation.dart';
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
  Future<bool> replyToUser(String receiverEmail, String content,
      String entityType, int entitySerial);
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

        // Fetch my profile once to resolve entities (images/questions)
        UserProfile? myProfile;
        try {
          // Retrieve the current user's email properly. LoginStore.email might be nullable.
          final myEmail = LoginStore.email;
          if (myEmail != null) {
            final myProfileMap =
                await _userProfileRepository.getUserProfile(myEmail);
            if (myProfileMap != null) {
              myProfile = UserProfile.fromJson(myProfileMap);
            }
          }
        } catch (e) {
          log('Error fetching my profile for entity resolution: $e');
        }

        // Concurrent fetching for updates logic (profiles AND confessions)
        final List<UpdateModel?> processedUpdates =
            await Future.wait(data.map((json) async {
          log("Processing update: $json"); // Debug log

          final senderEmail = json['senderEmail'] as String? ?? '';
          final userProfile = userProfileMap[senderEmail] ??
              UserProfile.fromEmail(
                  senderEmail.isEmpty ? 'Unknown User' : senderEmail);

          String? replyToText = json['repliedContent'];
          String? mediaUrl;
          String headerText = "Replied to your update"; // Default
          UpdateType type = UpdateType.textReply;

          // Check if it's a confession reply
          if (json['confessionId'] != null) {
            final confessionId = json['confessionId'] as String;
            final confession = await _confessionsRepository.getConfessionById(
                confessionId, encryptedEmail);
            if (confession != null) {
              replyToText = confession.text;
              headerText = "Replied to your confession";
              type = UpdateType.confessionReply;
            } else {
              log("Confession not found for id: $confessionId");
              return null;
            }
          } else {
            // Handle new entity types
            final entityType = json['entityType'] as String?;
            final entitySerial = json['entitySerial'] as int?;

            if (entityType == "IMAGES" && entitySerial != null) {
              type = UpdateType.profileReply;
              headerText = "Replied to your profile";
              if (myProfile != null && myProfile.images.length > entitySerial) {
                mediaUrl = myProfile.images[entitySerial].url;
              } else {
                log("Image entity not found or index out of bounds: $entitySerial");
              }
            } else if (entityType == "QUESTIONS" && entitySerial != null) {
              type = UpdateType.textReply;
              headerText = "Replied to your answer";
              if (myProfile != null &&
                  myProfile.surpriseQuiz.length > entitySerial) {
                // User said "answer at the top".
                replyToText = myProfile.surpriseQuiz[entitySerial].answer;
              } else {
                log("Question entity not found or index out of bounds: $entitySerial");
              }
            }
          }

          return UpdateModel(
            id: json['_id'] ?? '',
            senderUser: userProfile,
            type: type,
            headerText: headerText,
            replyText: json['replyContent'] ?? '',
            replyTo: replyToText,
            mediaUrl: mediaUrl,
            timestamp:
                DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
          );
        }));

        final allUpdates = processedUpdates.whereType<UpdateModel>().toList();

        if (filter == 'All') {
          return allUpdates;
        } else if (filter == 'Confession') {
          return allUpdates
              .where((u) => u.type == UpdateType.confessionReply)
              .toList();
        } else if (filter == 'Match') {
          return allUpdates.where((u) => u.type == UpdateType.match).toList();
        } else if (filter == 'Profile') {
          return allUpdates
              .where((u) =>
                  u.type == UpdateType.profileReply ||
                  u.type == UpdateType.textReply ||
                  u.type == UpdateType.voiceReply)
              .toList();
        }
        return allUpdates;
      }
    } catch (e) {
      log('Error fetching updates: $e');
    }
    return [];
  }

  @override
  Future<bool> replyToUser(String receiverEmail, String content,
      String entityType, int entitySerial) async {
    debugPrint("REPO: replyToUser called");
    debugPrint(
        "REPO: Receiver: $receiverEmail, Type: $entityType, Serial: $entitySerial");
    try {
      final payload = {
        'isConfession': false,
        'receiverEmail': receiverEmail,
        'replyContent': content,
        'entityType': entityType,
        'entitySerial': entitySerial,
      };
      debugPrint("REPO: Sending payload: $payload");

      final response = await _apiRepository.dio.post(
        Endpoints.postReply,
        data: payload,
      );

      debugPrint("REPO: Response Status: ${response.statusCode}");
      debugPrint("REPO: Response Data: ${response.data}");

      if (response.statusCode == 200 && response.data['success'] == true) {
        debugPrint('REPO: Reply to user successful!');
        return true;
      }
      debugPrint("REPO: Failed to reply to user: ${response.data}");
      return false;
    } catch (e, stack) {
      debugPrint('REPO: Error replying to user: $e');
      debugPrint('REPO: Stack trace: $stack');
      return false;
    }
  }
}
