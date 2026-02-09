import 'dart:developer';

import 'package:college_cupid/domain/models/update_model.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/presentation/widgets/updates/match_update_card.dart';
import 'package:college_cupid/presentation/widgets/updates/confession_reply_card.dart';
import 'package:college_cupid/presentation/widgets/updates/voice_note_reply_card.dart';
import 'package:college_cupid/presentation/widgets/updates/profile_reply_card.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateItemBuilder extends ConsumerStatefulWidget {
  final UpdateModel update;

  const UpdateItemBuilder({super.key, required this.update});

  @override
  ConsumerState<UpdateItemBuilder> createState() => _UpdateItemBuilderState();
}

class _UpdateItemBuilderState extends ConsumerState<UpdateItemBuilder> {
  late UpdateModel _update;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _update = widget.update;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSenderProfile();
    });
  }

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

  Future<void> _fetchSenderProfile() async {
    final senderEmail = _update.senderEmail;

    if (senderEmail == null || senderEmail.isEmpty) {
      // No email to fetch, use existing data
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final userProfileRepo = ref.read(userProfileRepoProvider);
      final profileMap = await userProfileRepo.getUserProfile(senderEmail);

      if (profileMap == null) {
        // Profile not found, keep existing senderUser
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      final senderProfile = UserProfile.fromJson(profileMap);

      if (mounted) {
        setState(() {
          _update = UpdateModel(
            id: _update.id,
            senderUser: senderProfile,
            type: _update.type,
            headerText: _update.headerText,
            timestamp: _update.timestamp,
            replyText: _decryptProfileReply(
              _update.replyText ?? '',
              _update.type,
              senderProfile.publicKey,
            ),
            replyTo: _update.replyTo,
            mediaUrl: _update.mediaUrl,
            senderEmail: _update.senderEmail,
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      // Error fetching profile, keep existing senderUser
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // While loading, show a minimal placeholder
    if (_isLoading) {
      return const SizedBox.shrink();
    }

    switch (_update.type) {
      case UpdateType.match:
        return MatchUpdateCard(update: _update);
      case UpdateType.blindDateReply:
        return MatchUpdateCard(update: _update, blindMatch: true);
      case UpdateType.voiceReply:
        return VoiceNoteReplyCard(update: _update);
      case UpdateType.profileReply:
        return ProfileReplyCard(update: _update);
      case UpdateType.textReply:
      case UpdateType.confessionReply:
        return ConfessionReplyCard(update: _update);
    }
  }
}
