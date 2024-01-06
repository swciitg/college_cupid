import 'dart:async';

import 'package:college_cupid/models/user_profile.dart';
import 'package:college_cupid/stores/filter_store.dart';
import 'package:college_cupid/widgets/home/filter_bottom_sheet.dart';
import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/widgets/home/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int pageNumber = 0;
  bool isLastPage = false;

  List<ProfileCard> pages = [];

  final _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
  Timer? timer;

  Future<dynamic> showFilterSheet(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return const FilterBottomSheet();
        });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterStore = context.read<FilterStore>();
    return Observer(
      builder: (_) => RefreshIndicator(
        onRefresh: () async {
          print("*******************REFRESH***************");
        },
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: CupidColors.titleColor,
                      ),
                      color: CupidColors.backgroundColor,
                    ),
                    child: TextFormField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (value) {
                        // if (mounted) {
                        //   setState(() {
                        //     getUserProfilesFuture = APIService()
                        //         .getAllSearchedUserProfiles(value);
                        //   });
                        // }
                      },
                      onChanged: (value) {
                        if (timer != null) timer!.cancel();
                        timer = Timer(const Duration(seconds: 1), () {
                          // print('timer');
                          // if (mounted) {
                          //   setState(() {
                          //     getUserProfilesFuture = APIService()
                          //         .getAllSearchedUserProfiles(value);
                          //   });
                          // }
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Filter'),
                IconButton(
                  icon: Image.asset('assets/icons/filter.png', height: 32),
                  onPressed: () {
                    showFilterSheet(context);
                  },
                ),
              ],
            ),
            FutureBuilder(
              future: APIService().getPaginatedUsers(pageNumber, {
                'gender': filterStore.interestedInGender.databaseString,
                'program': filterStore.program.databaseString,
                'yearOfJoin': filterStore.yearOfJoin
              }),
              builder: (context, snapshot) {
                if (snapshot.hasData == false) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                pages =
                    snapshot.data!.map((e) => ProfileCard(user: e)).toList();
                return Expanded(
                  child: PageView(
                    allowImplicitScrolling: false,
                    onPageChanged: (value) async {
                      if (isLastPage) return;
                      print(
                          '*******************${pages.length}**********************');
                      if (pages.length - value <= 4) {
                        pageNumber++;
                        final List<UserProfile> users =
                            await APIService().getPaginatedUsers(pageNumber, {
                          'gender':
                              filterStore.interestedInGender.databaseString,
                          'program': filterStore.program.databaseString,
                          'yearOfJoin': filterStore.yearOfJoin
                        });
                        if (users.length < 10) isLastPage = true;
                        for (UserProfile user in users) {
                          pages.add(ProfileCard(user: user));
                        }
                      }
                    },
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    children: pages,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
