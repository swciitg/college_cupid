import 'dart:developer';

import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/repositories/crushes_repository.dart';
import 'package:college_cupid/repositories/onedrive_repository.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final crushesServiceProvider = Provider<CrushesService>((ref) {
  final crushesRepo = ref.watch(crushesRepoProvider);
  final userProfileRepo = ref.watch(userProfileRepoProvider);
  return CrushesService(
      crushesRepository: crushesRepo, userProfileRepository: userProfileRepo);
});

class CrushesService {
  final CrushesRepository crushesRepository;
  final UserProfileRepository userProfileRepository;

  CrushesService({
    required this.crushesRepository,
    required this.userProfileRepository,
  });

  Future<List<UserProfile>> getCrushProfiles() async {
    try {
      final crushEmails = await OneDriveRepository.getMyCrushes();
      List<UserProfile> crushesProfiles = [];
      for (String email in crushEmails) {
        final profileMap = await userProfileRepository.getUserProfile(email);
        if (profileMap == null) continue;
        final profile = UserProfile.fromJson(profileMap);
        crushesProfiles.add(profile);
      }
      return crushesProfiles;
    } catch (err) {
      log("message: $err");
      rethrow;
    }
  }

  Future<bool> removeCrush(int index, String email) async {
    final status = await crushesRepository.removeCrush(index);
    if (status) {
      await OneDriveRepository.removeCrush(index);
      await crushesRepository.decreaseCrushesCount(email);
    }
    return status;
  }
}
