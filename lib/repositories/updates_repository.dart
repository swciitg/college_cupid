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

final updatesRepoProvider = Provider<UpdatesRepository>((ref) => UpdatesRepositoryImpl(
    ref.read(apiRepositoryProvider),
    ref.read(userProfileRepoProvider),
    ref.read(confessionsRepoProvider)));

abstract class UpdatesRepository {
  Future<List<UpdateModel>> fetchUpdates({String? filter});
  Future<bool> replyToUser(
    String receiverEmail,
    String content,
    String entityType,
    int entitySerial, {
    String? receiverPublicKey, // Optional: only needed for profile replies
  });
  Future<bool> deleteAllUpdates();
}

class UpdatesRepositoryImpl implements UpdatesRepository {
  final ApiRepository _apiRepository;
  final UserProfileRepository _userProfileRepository;
  final ConfessionsRepository _confessionsRepository;

  UpdatesRepositoryImpl(
      this._apiRepository, this._userProfileRepository, this._confessionsRepository);

  /// Decrypts profile reply content if it's a profile reply type
  String _decryptProfileReply(String content, UpdateType type, String? senderPublicKey) {
    // Only decrypt profile-related replies (IMAGES and QUESTIONS)
    if (type != UpdateType.profileReply && type != UpdateType.textReply) {
      return content;
    }

    // Check if user has a private key
    if (LoginStore.dhPrivateKey == null || LoginStore.dhPrivateKey!.isEmpty) {
      log('Warning: No private key available for decryption');
      return content;
    }

    // Check if sender's public key is available
    if (senderPublicKey == null || senderPublicKey.isEmpty) {
      log('Warning: Sender public key not available for decryption');
      return content;
    }

    try {
      // Decrypt using shared secret (my private key + their public key)
      final decrypted = Encryption.decryptWithSharedSecret(
        encryptedMessage: content,
        myPrivateKey: LoginStore.dhPrivateKey!,
        theirPublicKey: senderPublicKey,
      );
      log('Successfully decrypted profile reply using shared secret');
      return decrypted;
    } catch (e) {
      log('Error decrypting profile reply: $e');
      // Return original content if decryption fails
      return content;
    }
  }

  @override
  Future<List<UpdateModel>> fetchUpdates({String? filter}) async {
    try {
      final encryptedEmail = Encryption.encryptEmail(LoginStore.email!, Endpoints.apiSecurityKey);
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
            final profileMap = await _userProfileRepository.getUserProfile(email);
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
            final myProfileMap = await _userProfileRepository.getUserProfile(myEmail);
            if (myProfileMap != null) {
              myProfile = UserProfile.fromJson(myProfileMap);
            }
          }
        } catch (e) {
          log('Error fetching my profile for entity resolution: $e');
        }

        // Concurrent fetching for updates logic (profiles AND confessions)
        final List<UpdateModel?> processedUpdates = await Future.wait(data.map((json) async {
          log("Processing update: $json"); // Debug log

          final senderEmail = json['senderEmail'] as String? ?? '';
          final userProfile = userProfileMap[senderEmail] ??
              UserProfile.fromEmail(senderEmail.isEmpty ? 'Unknown User' : senderEmail);

          String? replyToText = json['repliedContent'];
          String? mediaUrl;
          String headerText = "Replied to your update"; // Default
          UpdateType type = UpdateType.textReply;

          // Check if it's a confession reply
          if (json['confessionId'] != null) {
            final confessionId = json['confessionId'] as String;
            final confession =
                await _confessionsRepository.getConfessionById(confessionId, encryptedEmail);
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
              if (myProfile != null && myProfile.surpriseQuiz.length > entitySerial) {
                // User said "answer at the top".
                replyToText = myProfile.surpriseQuiz[entitySerial].answer;
              } else {
                log("Question entity not found or index out of bounds: $entitySerial");
              }
            } else if (entityType == 'MATCHES' && entitySerial != null) {
              type = UpdateType.match;
              headerText = "It's a match!";
              // For matches, we might want to fetch the matched user's profile
              // Assuming the mediaUrl field can be repurposed to store the matched user's email for now
              // mediaUrl = json['matchedUserEmail'] as String?;
            } else if (entityType == 'BLIND_DATING_MATCH' && entitySerial != null) {
              type = UpdateType.blindDateReply;
              headerText = "Replied to your blind date profile";
            }
          }

          return UpdateModel(
            id: json['_id'] ?? '',
            senderUser: userProfile,
            type: type,
            headerText: headerText,
            replyText: _decryptProfileReply(
              json['replyContent'] ?? '',
              type,
              userProfile.publicKey,
            ),
            replyTo: replyToText,
            mediaUrl: mediaUrl,
            timestamp: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
            senderEmail: json['senderEmail'] as String?,
          );
        }));

        final allUpdates = processedUpdates.whereType<UpdateModel>().toList();

        if (filter == 'All') {
          return allUpdates;
        } else if (filter == 'Confession') {
          return allUpdates.where((u) => u.type == UpdateType.confessionReply).toList();
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
  Future<bool> replyToUser(
    String receiverEmail,
    String content,
    String entityType,
    int entitySerial, {
    String? receiverPublicKey,
  }) async {
    debugPrint("REPO: replyToUser called");
    debugPrint("REPO: Receiver: $receiverEmail, Type: $entityType, Serial: $entitySerial");

    try {
      // Encrypt content for profile replies (IMAGES and QUESTIONS)
      String finalContent = content;
      if ((entityType == 'IMAGES' || entityType == 'QUESTIONS') &&
          receiverPublicKey != null &&
          receiverPublicKey.isNotEmpty &&
          LoginStore.dhPrivateKey != null &&
          LoginStore.dhPrivateKey!.isNotEmpty) {
        finalContent = Encryption.encryptWithSharedSecret(
          message: content,
          myPrivateKey: LoginStore.dhPrivateKey!,
          theirPublicKey: receiverPublicKey,
        );
      }

      final payload = {
        'isConfession': false,
        'receiverEmail': receiverEmail,
        'replyContent': finalContent,
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

  @override
  Future<bool> deleteAllUpdates() async {
    try {
      log('Deleting all updates for current user');
      final response = await _apiRepository.dio.delete(Endpoints.deleteUpdates);

      if (response.statusCode == 200 && response.data['success'] == true) {
        log('All updates deleted successfully: ${response.data['message']}');
        return true;
      }
      log('Failed to delete updates: ${response.data}');
      return false;
    } catch (e) {
      log('Error deleting updates: $e');
      return false;
    }
  }
}
