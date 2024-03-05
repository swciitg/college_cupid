import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/models/user_profile.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/routing/app_routes.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/globals.dart';
import 'package:college_cupid/widgets/global/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MatchInfo extends ConsumerWidget {
  final String email;

  const MatchInfo({required this.email, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileRepo = ref.read(userProfileRepoProvider);
    return Container(
      margin: const EdgeInsets.only(top: 32),
      height: 66,
      width: 295,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: CupidColors.pinkColor),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: FutureBuilder(
        future: userProfileRepo.getUserProfile(email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomLoader();
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return GestureDetector(
              onTap: () {
                context.pushNamed(AppRoutes.userProfileScreen.name, extra: {
                  'isMine': false,
                  'userProfile': UserProfile.fromJson(snapshot.data!)
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'profilePic',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(19),
                        right: Radius.zero,
                      ),
                      child: SizedBox.fromSize(
                        child: CachedNetworkImage(
                            imageUrl:
                                snapshot.data!['profilePicUrl'].toString(),
                            cacheManager: customCacheManager,
                            progressIndicatorBuilder:
                                (context, url, progress) => Center(
                                      child: CircularProgressIndicator(
                                        value: progress.progress,
                                      ),
                                    ),
                            fit: BoxFit.cover,
                            width: 64,
                            height: 66),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Container(
                            margin: const EdgeInsets.only(top: 9),
                            child: Text(
                              snapshot.data!['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                color: CupidColors.blackColor,
                                fontFamily: 'Sk-Modernist',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${Program.values.firstWhere((p) => p.databaseString == snapshot.data!['program']).displayString} '${snapshot.data!['yearOfJoin']}",
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
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
