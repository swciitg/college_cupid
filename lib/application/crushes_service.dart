import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/repositories/crushes_repository.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/stores/login_store.dart';
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

  CrushesService(
      {required this.crushesRepository, required this.userProfileRepository});

  Future<List<UserProfile>> getCrushProfiles() async {
    final crushEmails = await crushesRepository.getCrushes();
    List<UserProfile> crushesProfiles = [];
    for (String email in crushEmails) {
      final String plainTextEmail = Encryption.decryptAES(
              encryptedText: Encryption.hexadecimalToBytes(email),
              key: LoginStore.password!)
          .replaceAll(RegExp(r'^0+'), '');
      final profileMap =
          await userProfileRepository.getUserProfile(plainTextEmail);
      final profile = UserProfile.fromJson(profileMap!);
      crushesProfiles.add(profile);
    }
    return crushesProfiles;
  }

  Future<bool> removeCrush(int index, String email) async {
    final status = await crushesRepository.removeCrush(index);
    if (status) {
      await crushesRepository.decreaseCrushesCount(email);
    }
    return status;
  }
}
