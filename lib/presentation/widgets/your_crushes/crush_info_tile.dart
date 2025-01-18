import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/controllers/crushes_controller.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/routing/app_router.dart';

import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CrushInfoTile extends ConsumerWidget {
  final UserProfile profile;
  final int index;

  const CrushInfoTile({required this.profile, required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final program = Program.values.firstWhere((p) => p.databaseString == profile.program);
    final crushesList = ref.read(crushesControllerProvider.notifier);

    return Container(
      margin: const EdgeInsets.only(top: 32),
      height: 66,
      width: 295,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: CupidColors.pinkColor),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(AppRoutes.userProfileScreen.name,
              extra: {'isMine': false, 'userProfile': profile});
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Hero(
              tag: 'profilePic',
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(19), right: Radius.zero),
                // Image border
                child: SizedBox.fromSize(
                  child: CachedNetworkImage(
                      imageUrl: profile.profilePicUrl,
                      cacheManager: customCacheManager,
                      progressIndicatorBuilder: (context, url, progress) => const CustomLoader(),
                      fit: BoxFit.cover,
                      width: 64,
                      height: 66),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      profile.name,
                      style: const TextStyle(
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: CupidColors.blackColor,
                        fontFamily: 'Sk-Modernist',
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${program.displayString} '${profile.yearOfJoin}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: CupidColors.blackColor,
                      fontFamily: 'Sk-Modernist',
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            GestureDetector(
              onTap: () async {
                await crushesList.removeCrush(index, profile.email);
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.close,
                  color: CupidColors.pinkColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
