import 'package:blurhash_ffi/blurhashffi_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/functions/diffie_hellman.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/presentation/screens/profile/view_profile/user_profile_screen.dart';
import 'package:college_cupid/repositories/crushes_repository.dart';
import 'package:college_cupid/repositories/onedrive_repository.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/globals.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class CrushCard extends ConsumerStatefulWidget {
  final String email;

  const CrushCard({required this.email, super.key});

  @override
  ConsumerState<CrushCard> createState() => _CrushCardState();
}

class _CrushCardState extends ConsumerState<CrushCard> {
  bool _isRemoving = false;
  bool _isLoading = true;
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final userProfileRepo = ref.read(userProfileRepoProvider);
      final profileMap = await userProfileRepo.getUserProfile(widget.email);

      if (profileMap == null) {
        // Profile not found, keep _profile as null
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      final profile = UserProfile.fromJson(profileMap);
      if (mounted) {
        setState(() {
          _profile = profile;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Error fetching profile, keep _profile as null
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // If still loading, show nothing
    if (_isLoading) {
      return const SizedBox.shrink();
    }

    // If profile not found, hide the card
    if (_profile == null) {
      return const SizedBox.shrink();
    }

    final program = Program.values.firstWhere((p) => p == _profile!.program);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              spreadRadius: 4,
            )
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserProfileScreen(
                  isMine: false,
                  userProfile: _profile!,
                  showPass: false,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _profileImage(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _profile!.name,
                        style: CupidTextStyles.title2.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${program.displayString} '${_profile!.yearOfJoin}",
                        style: CupidTextStyles.label2,
                      ),
                    ],
                  ),
                ),
                _isRemoving
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: CupidColors.red,
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: () async {
                          setState(() {
                            _isRemoving = true;
                          });
                          try {
                            final crushesRepo = ref.read(crushesRepoProvider);

                            if (LoginStore.dhPrivateKey == null) {
                              if (mounted) {
                                setState(() {
                                  _isRemoving = false;
                                });
                              }
                              return;
                            }

                            // Calculate shared secret
                            final sharedSecret = DiffieHellman.generateSharedSecret(
                              otherPublicKey: BigInt.parse(_profile!.publicKey),
                              myPrivateKey: BigInt.parse(LoginStore.dhPrivateKey!),
                            ).toString();

                            // Remove from backend
                            final status = await crushesRepo.removeCrush(sharedSecret);

                            if (status) {
                              // Remove from OneDrive
                              await OneDriveRepository.removeCrush(_profile!.email);
                              // Decrease crush count
                              await crushesRepo.decreaseCrushesCount(_profile!.email);

                              // Hide this card by setting profile to null
                              if (mounted) {
                                setState(() {
                                  _profile = null;
                                  _isRemoving = false;
                                });
                              }
                            } else {
                              if (mounted) {
                                setState(() {
                                  _isRemoving = false;
                                });
                                showSnackBar('Failed to remove crush. Please try again.');
                              }
                            }
                          } catch (e) {
                            if (mounted) {
                              setState(() {
                                _isRemoving = false;
                              });
                              showSnackBar('Failed to remove crush. Please try again.');
                            }
                          }
                        },
                        icon: const Icon(
                          FluentIcons.dismiss_circle_24_filled,
                          color: CupidColors.red,
                          size: 28,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: _profile!.images.first.url,
        cacheManager: customCacheManager,
        fit: BoxFit.cover,
        height: 80,
        width: 80,
        placeholder: (context, url) => BlurhashFfi(hash: _profile!.images.first.blurHash!),
        errorWidget: (context, url, error) => Container(
          color: CupidColors.primaryLight,
          child: const Center(
            child: Icon(Icons.person, size: 40, color: CupidColors.primary),
          ),
        ),
      ),
    );
  }
}
