import 'dart:developer';

import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/presentation/widgets/profile/display_profile_info.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/filter_store.dart';
import 'package:college_cupid/stores/page_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:college_cupid/functions/diffie_hellman.dart';
import 'package:college_cupid/repositories/crushes_repository.dart';
import 'package:college_cupid/repositories/storage_provider.dart';
import 'package:college_cupid/stores/login_store.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  late FilterState filterStore;
  late FilterNotifier filterController;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageViewState = ref.watch(pageViewProvider);
    final pageViewNotifier = ref.read(pageViewProvider.notifier);

    // Safety check for index out of bounds
    if (pageViewState.homeTabProfileList.isEmpty ||
        pageViewNotifier.currentPage >= pageViewState.homeTabProfileList.length) {
      if (pageViewState.loading) {
        return const Center(child: CustomLoader());
      }
      return const Center(
        child: Text(
          'No users as of now...',
          style: CupidTextStyles.body1,
        ),
      );
    }

    final currentUser = pageViewState.homeTabProfileList[pageViewNotifier.currentPage];

    return DisplayProfileInfo(
      userProfile: currentUser,
      onPass: () {
        pageViewNotifier.nextProfile();
      },
      onSmash: () async {
        final crushesRepo = ref.read(crushesRepoProvider);
        final profile = currentUser;

        if (LoginStore.dhPrivateKey == null) {
          return;
        }

        final sharedSecret = DiffieHellman.generateSharedSecret(
          otherPublicKey: BigInt.parse(profile.publicKey),
          myPrivateKey: BigInt.parse(LoginStore.dhPrivateKey!),
        ).toString();

        // Optimistically move to next profile
        pageViewNotifier.nextProfile();

        try {
          bool success = await crushesRepo.addCrush(sharedSecret);
          if (success) {
            final storageRepo = ref.read(storageRepositoryProvider);
            await storageRepo.addCrush(profile.email);
            await crushesRepo.increaseCrushesCount(profile.email);
          }
        } catch (e) {
          // Handle error
          log("Error adding crush: $e");
        }
      },
    );
  }
}
