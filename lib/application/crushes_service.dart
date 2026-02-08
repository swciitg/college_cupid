import 'dart:developer';

import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/repositories/crushes_repository.dart';
import 'package:college_cupid/repositories/storage_provider.dart';
import 'package:college_cupid/repositories/storage_repository.dart';
// import 'package:college_cupid/repositories/google_drive_repository.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final crushesServiceProvider = Provider<CrushesService>((ref) {
  final crushesRepo = ref.watch(crushesRepoProvider);
  final userProfileRepo = ref.watch(userProfileRepoProvider);
  final storageRepo = ref.watch(storageRepositoryProvider);
  return CrushesService(
    crushesRepository: crushesRepo,
    userProfileRepository: userProfileRepo,
    storageRepository: storageRepo,
  );
});

class CrushesService {
  final CrushesRepository crushesRepository;
  final UserProfileRepository userProfileRepository;
  final StorageRepository storageRepository;

  CrushesService({
    required this.crushesRepository,
    required this.userProfileRepository,
    required this.storageRepository,
  });

  Future<List<UserProfile>> getCrushProfiles() async {
    try {
      final crushEmails = await storageRepository.getMyCrushes();
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
      await storageRepository.removeCrush(index);
      await crushesRepository.decreaseCrushesCount(email);
    }
    return status;
  }
}
