import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/functions/diffie_hellman.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/presentation/widgets/home/drawer_widget.dart';
import 'package:college_cupid/presentation/widgets/profile/display_profile_info.dart';
import 'package:college_cupid/repositories/crushes_repository.dart';
import 'package:college_cupid/repositories/onedrive_repository.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final UserProfile userProfile;
  final bool isMine;
  final bool showPass;
  final Color? backgroundColor;

  const UserProfileScreen({
    required this.isMine,
    required this.userProfile,
    this.showPass = true,
    this.backgroundColor,
    super.key,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  late UserProfile profile;

  @override
  void initState() {
    profile = widget.userProfile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myProfile = ref.watch(userProvider).myProfile;
    final profileToShow = widget.isMine ? myProfile ?? widget.userProfile : widget.userProfile;

    return Scaffold(
      backgroundColor: widget.backgroundColor ?? CupidColors.backgroundColor,
      drawer: widget.isMine ? const DrawerWidget() : null,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: DisplayProfileInfo(
                    userProfile: profileToShow,
                    isMine: widget.isMine,
                    backButton: !widget.isMine,
                    showPass: widget.showPass,
                    onSmash: () async {
                      final crushesRepo = ref.read(crushesRepoProvider);
                      if (LoginStore.dhPrivateKey == null) return;

                      final sharedSecret = DiffieHellman.generateSharedSecret(
                        otherPublicKey: BigInt.parse(profileToShow.publicKey),
                        myPrivateKey: BigInt.parse(LoginStore.dhPrivateKey!),
                      ).toString();

                      try {
                        bool success =
                            await crushesRepo.addCrush(sharedSecret, profileToShow.email);
                        if (success) {
                          await OneDriveRepository.addCrush(profileToShow.email);
                          await crushesRepo.increaseCrushesCount(profileToShow.email);
                          if (mounted) {
                            showSnackBar('Added to crushes!');
                          }
                        }
                      } catch (e) {
                        debugPrint("Error adding crush: $e");
                      }
                    },
                    onDislike: () async {
                      final crushesRepo = ref.read(crushesRepoProvider);
                      if (LoginStore.dhPrivateKey == null) return;

                      try {
                        // Calculate shared secret
                        final sharedSecret = DiffieHellman.generateSharedSecret(
                          otherPublicKey: BigInt.parse(profileToShow.publicKey),
                          myPrivateKey: BigInt.parse(LoginStore.dhPrivateKey!),
                        ).toString();

                        // Remove from backend using sharedSecret
                        await crushesRepo.removeCrush(sharedSecret);

                        // Remove from OneDrive using email
                        await OneDriveRepository.removeCrush(profileToShow.email);

                        // Decrease crush count
                        await crushesRepo.decreaseCrushesCount(profileToShow.email);

                        if (mounted) {
                          showSnackBar('Removed from crushes');
                          // Refresh the UI by going back
                          Navigator.of(context).pop();
                        }
                      } catch (e) {
                        debugPrint("Error removing crush: $e");
                        if (mounted) {
                          showSnackBar('Failed to remove crush');
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
