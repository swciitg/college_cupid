import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/profile/display_profile_info.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/filter_store.dart';
import 'package:college_cupid/stores/page_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileView extends ConsumerStatefulWidget {
  final List<UserProfile> userProfiles;

  const ProfileView({required this.userProfiles, super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  late FilterState filterStore;
  late PageViewState pageViewState;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfileRepo = ref.read(userProfileRepoProvider);
    filterStore = ref.watch(filterProvider);
    pageViewState = ref.watch(pageViewProvider);
    _pageController = PageController(initialPage: ref.read(pageViewProvider.notifier).currentPage);
    if (pageViewState.homeTabProfileList.isEmpty) {
      return const Center(
        child: Text(
          'No users as of now...',
          style: CupidStyles.lightTextStyle,
        ),
      );
    }

    return PageView(
      padEnds: true,
      key: Key(widget.userProfiles.hashCode.toString()),
      allowImplicitScrolling: false,
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      onPageChanged: (value) async {
        final pageViewController = ref.read(pageViewProvider.notifier);
        ref.read(pageViewProvider.notifier).setCurrentPage(value);
        if (pageViewController.isLastPage) return;
        if (pageViewState.homeTabProfileList.length - value <= 4) {
          ref.read(pageViewProvider.notifier).setPageNumber(pageViewController.pageNumber + 1);
          final List<UserProfile> users =
              await userProfileRepo.getPaginatedUsers(pageViewController.pageNumber, {
            'gender': filterStore.interestedInGender.databaseString,
            'program': filterStore.program.databaseString,
            'yearOfJoin': filterStore.yearOfJoin,
            'name': filterStore.name
          });
          if (users.length < 10) {
            ref.read(pageViewProvider.notifier).setIsLastPage(true);
          }
          ref.read(pageViewProvider.notifier).addHomeTabProfiles(
                users,
                search: filterStore.name.isNotEmpty,
              );
        }
      },
      children: List.generate(
        pageViewState.homeTabProfileList.length,
        (index) {
          return DisplayProfileInfo(
            userProfile: pageViewState.homeTabProfileList[index],
          );
        },
      ),
    );
  }
}
