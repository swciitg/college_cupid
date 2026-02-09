import 'package:blurhash_ffi/blurhashffi_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/routing/app_router.dart';

import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/globals.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/blocked_users_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BlockedUserInfoTile extends ConsumerWidget {
  final String email;
  final int index;
  final BlockedUsersStore blockedUsersStore;

  const BlockedUserInfoTile(
      {required this.email, required this.blockedUsersStore, required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileRepo = ref.read(userProfileRepoProvider);
    return FutureBuilder(
      future: userProfileRepo.getUserProfile(email),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomLoader();
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Center(
              child: Text(snapshot.hasError ? snapshot.error.toString() : 'User not found'));
        } else {
          final profile = UserProfile.fromJson(snapshot.data!);
          final program = Program.values.firstWhere((p) => p == profile.program);

          return Padding(
            padding: const EdgeInsets.only(top: 8),
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
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  context.pushNamed(
                    AppRoutes.userProfileScreen.name,
                    extra: {
                      'isMine': false,
                      'userProfile': profile,
                    },
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _profileImage(profile),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            profile.name,
                            style: CupidTextStyles.title2.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${program.displayString} '${profile.yearOfJoin}",
                            style: CupidTextStyles.label2,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await blockedUsersStore.unblockUser(index);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: CupidColors.secondaryColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _profileImage(UserProfile profile) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      // Image border
      child: CachedNetworkImage(
        imageUrl: profile.images.first.url,
        cacheManager: customCacheManager,
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 100),
        placeholder: (context, url) {
          if (profile.images.first.blurHash == null) {
            return const CustomLoader();
          }
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BlurhashFfi(hash: profile.images.first.blurHash!),
          );
        },
        errorWidget: (context, url, error) {
          if (profile.images.first.blurHash == null) {
            return const CustomLoader();
          }
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BlurhashFfi(hash: profile.images.first.blurHash!),
          );
        },
        fit: BoxFit.cover,
        width: 80,
        height: 80,
      ),
    );
  }
}
