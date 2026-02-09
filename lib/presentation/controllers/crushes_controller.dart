import 'dart:async';
import 'dart:developer';

import 'package:college_cupid/application/crushes_service.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/functions/diffie_hellman.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final crushesControllerProvider =
    StateNotifierProvider.autoDispose<CrushesController, AsyncValue<List<UserProfile>>>((ref) {
  return CrushesController(crushesService: ref.read(crushesServiceProvider));
});

class CrushesController extends StateNotifier<AsyncValue<List<UserProfile>>> {
  final CrushesService crushesService;

  CrushesController({required this.crushesService}) : super(const AsyncLoading());

  Future<void> getCrushProfiles() async {
    try {
      state = const AsyncLoading();
      state = await AsyncValue.guard<List<UserProfile>>(() {
        return crushesService.getCrushProfiles();
      });
    } catch (e) {
      log("$e");
    }
  }

  Future<void> removeCrush(UserProfile profile) async {
    state = const AsyncLoading<List<UserProfile>>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      // Calculate shared secret
      final sharedSecret = DiffieHellman.generateSharedSecret(
        otherPublicKey: BigInt.parse(profile.publicKey),
        myPrivateKey: BigInt.parse(LoginStore.dhPrivateKey!),
      ).toString();

      final status = await crushesService.removeCrush(sharedSecret, profile.email);
      List<UserProfile> newList = List.from(state.value!);
      if (status) {
        newList.removeWhere((p) => p.email == profile.email);
      }
      return newList;
    });
  }
}
