import 'package:blurhash_ffi/blurhashffi_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/globals.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MatchInfo extends ConsumerWidget {
  final String email;

  const MatchInfo({required this.email, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileRepo = ref.read(userProfileRepoProvider);
    return FutureBuilder(
      future: userProfileRepo.getUserProfile(email),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomLoader();
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else {
          final profile = UserProfile.fromJson(snapshot.data!);
          final program = Program.values.firstWhere((p) => p == profile.program);
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: GestureDetector(
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
                    _profileImage(profile),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            profile.name,
                            style: CupidStyles.normalTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${program.displayString} '${profile.yearOfJoin}",
                            style: CupidStyles.normalTextStyle,
                          ),
                        ],
                      ),
                    ),
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
      child: CachedNetworkImage(
        imageUrl: profile.images.first.url,
        cacheManager: customCacheManager,
        placeholder: (context, url) {
          if (profile.images.first.blurHash == null) return const CustomLoader();
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BlurhashFfi(hash: profile.images.first.blurHash!),
          );
        },
        errorWidget: (context, url, error) {
          if (profile.images.first.blurHash == null) return const CustomLoader();
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
