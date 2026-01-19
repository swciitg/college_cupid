import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/presentation/widgets/profile/display_profile_info.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/filter_store.dart';
import 'package:college_cupid/stores/page_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:college_cupid/functions/diffie_hellman.dart';
import 'package:college_cupid/repositories/crushes_repository.dart';
import 'package:college_cupid/repositories/onedrive_repository.dart';
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
    // filterStore and filterController are not used in build but kept for logic if needed
    // filterStore = ref.watch(filterProvider);
    // filterController = ref.read(filterProvider.notifier);

    final pageViewState = ref.watch(pageViewProvider);
    final pageViewNotifier = ref.read(pageViewProvider.notifier);

    // Safety check for index out of bounds
    if (pageViewState.homeTabProfileList.isEmpty ||
        pageViewNotifier.currentPage >=
            pageViewState.homeTabProfileList.length) {
      if (pageViewState.loading) {
        return const Center(child: CustomLoader());
      }
      return const Center(
        child: Text(
          'No users as of now...',
          style: CupidStyles.lightTextStyle,
        ),
      );
    }

    final currentUser =
        pageViewState.homeTabProfileList[pageViewNotifier.currentPage];

    return DisplayProfileInfo(
      userProfile: currentUser,
      onPass: () {
        pageViewNotifier.nextProfile();
      },
      onSmash: () async {
        final crushesRepo = ref.read(crushesRepoProvider);
        final profile = currentUser;

        if (LoginStore.dhPrivateKey == null) {
          // Handle missing key error if necessary
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
            await OneDriveRepository.addCrush(profile.email);
            await crushesRepo.increaseCrushesCount(profile.email);
          }
        } catch (e) {
          // Handle error (maybe undo? or just snackbar)
          print("Error adding crush: $e");
        }
      },
    );
  }

  // Helper methods _filters and _buildSearchField are removed from usage but kept in file if you prefer,
  // or I can delete them as they are no longer used.
  // The user asked to "remove search and filtering functionalities" but "utilize existing widgets... avoiding hardcoded colors".
  // The prompt said: "Remove search and filtering functionalities"
  // "Maintain code scalability and the app's core functionality."

  // I will just remove the methods to clean up the code.
}
