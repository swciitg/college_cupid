import 'dart:async';

import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/repositories/crushes_repository.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final crushesProvider =
    AutoDisposeAsyncNotifierProvider<CrushesNotifier, List<UserProfile>>(
        () => CrushesNotifier());

class CrushesNotifier extends AutoDisposeAsyncNotifier<List<UserProfile>> {
  @override
  Future<List<UserProfile>> build() async {
    final crushesRepo = ref.read(crushesRepoProvider);
    final userProfileRepo = ref.read(userProfileRepoProvider);

    final crushEmails = await crushesRepo.getCrushes();
    List<UserProfile> crushesProfiles = [];
    for (String email in crushEmails) {
      final profileMap = await userProfileRepo.getUserProfile(
          Encryption.decryptAES(
                  encryptedText: Encryption.hexadecimalToBytes(email),
                  key: LoginStore.password!)
              .replaceAll(RegExp(r'^0+(?=.)'), ''));
      final profile = UserProfile.fromJson(profileMap!);
      crushesProfiles.add(profile);
    }
    return crushesProfiles;
  }

  Future<void> removeCrush(int index, String email) async {
    final crushesRepo = ref.read(crushesRepoProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final status = await crushesRepo.removeCrush(index);
      List<UserProfile> newList = state.value!;
      if (status) {
        await crushesRepo.decreaseCrushesCount(email);
        newList.removeAt(index);
      }
      return newList;
    });
  }
}
