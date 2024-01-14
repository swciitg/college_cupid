import 'package:college_cupid/models/user_profile.dart';
import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/stores/filter_store.dart';
import 'package:college_cupid/stores/page_view_store.dart';
import 'package:college_cupid/widgets/home/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  final List<UserProfile> userProfiles;
  final PageController pageController;

  const ProfileView(
      {required this.pageController, required this.userProfiles, super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late FilterStore filterStore;
  late PageViewStore pageViewStore;

  @override
  void dispose() {
    pageViewStore.resetStore();
    filterStore.resetStore();
    widget.pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    filterStore = context.read<FilterStore>();
    pageViewStore = context.read<PageViewStore>();

    pageViewStore.setHomeTabProfiles(widget.userProfiles);
    pageViewStore.setIsLastPage(widget.userProfiles.length < 10);

    return Observer(builder: (nestedContext) {
      return SizedBox(
        height: screenHeight * 0.65,
        child: PageView(
          padEnds: true,
          key: Key(widget.userProfiles.hashCode.toString()),
          allowImplicitScrolling: false,
          controller: widget.pageController,
          scrollDirection: Axis.horizontal,
          onPageChanged: (value) async {
            if (pageViewStore.isLastPage) return;
            if (pageViewStore.homeTabProfileList.length - value <= 4) {
              pageViewStore.setPageNumber(pageViewStore.pageNumber + 1);
              final List<UserProfile> users = await APIService()
                  .getPaginatedUsers(pageViewStore.pageNumber, {
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
          children: pageViewStore.homeTabProfileList
              .map((element) => ProfileCard(user: element))
              .toList(),
        ),
      );
    });
  }
}
