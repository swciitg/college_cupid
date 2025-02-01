import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/home/profile_card.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/filter_store.dart';
import 'package:college_cupid/stores/page_view_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

class ProfileView extends ConsumerStatefulWidget {
  final List<UserProfile> userProfiles;

  const ProfileView({required this.userProfiles, super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  late FilterStore filterStore;
  late PageViewStore pageViewStore;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    pageViewStore.resetStore();
    filterStore.resetStore();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfileRepo = ref.read(userProfileRepoProvider);
    filterStore = context.read<FilterStore>();
    pageViewStore = context.read<PageViewStore>();

    pageViewStore.setHomeTabProfiles(widget.userProfiles);
    pageViewStore.setIsLastPage(widget.userProfiles.length < 10);

    if (widget.userProfiles.isEmpty) {
      return const Center(
        child: Text(
          'No users as of now...',
          style: CupidStyles.lightTextStyle,
        ),
      );
    }

    return Observer(
      builder: (nestedContext) {
        return PageView(
          padEnds: true,
          key: Key(widget.userProfiles.hashCode.toString()),
          allowImplicitScrolling: false,
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          onPageChanged: (value) async {
            if (pageViewStore.isLastPage) return;
            if (pageViewStore.homeTabProfileList.length - value <= 4) {
              pageViewStore.setPageNumber(pageViewStore.pageNumber + 1);
              final List<UserProfile> users =
                  await userProfileRepo.getPaginatedUsers(pageViewStore.pageNumber, {
                'gender': filterStore.interestedInGender.databaseString,
                'program': filterStore.program.databaseString,
                'yearOfJoin': filterStore.yearOfJoin,
                'name': filterStore.name
              });
              if (users.length < 10) {
                pageViewStore.setIsLastPage(true);
              }
              pageViewStore.addHomeTabProfiles(users);
            }
          },
          children: List.generate(
            pageViewStore.homeTabProfileList.length,
            (index) => ProfileCard(user: pageViewStore.homeTabProfileList[index]),
          ),
        );
      },
    );
  }
}
