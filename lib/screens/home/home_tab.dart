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
  bool isLastPage = false;

  List<ProfileCard> pages = [];

  final _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
  Timer? timer;

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterStore = context.read<FilterStore>();
    final double screenHeight = MediaQuery.of(context).size.height;
    return Observer(
      builder: (_) => SingleChildScrollView(
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
                        if (mounted) {
                          filterStore.setName(_searchController.text);
                        }
                      },
                      onChanged: (value) {
                        if (timer != null) timer!.cancel();
                        timer = Timer(const Duration(seconds: 1), () {
                          print('timer');
                          if (mounted) {
                            filterStore.setName(value);
                          }
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
                const Text('Filters'),
                IconButton(
                  icon: Image.asset('assets/icons/filter.png', height: 32),
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (_) {
                          return const FilterBottomSheet();
                        });
                  },
                ),
              ],
            ),
            FutureBuilder(
              future: APIService().getPaginatedUsers(filterStore.pageNumber, {
                'gender': filterStore.interestedInGender.databaseString,
                'program': filterStore.program.databaseString,
                'yearOfJoin': filterStore.yearOfJoin,
                'name': filterStore.name,
              }),
              builder: (context, snapshot) {
                if (snapshot.hasData == false) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                pages =
                    snapshot.data!.map((e) => ProfileCard(user: e)).toList();
                isLastPage = snapshot.data!.length < 10;
                return SizedBox(
                  height: 0.7 * screenHeight,
                  child: PageView(
                    allowImplicitScrolling: false,
                    onPageChanged: (value) async {
                      if (isLastPage) return;
                      print('PAGES LENGTH = ${pages.length}');
                      if (pages.length - value <= 4) {
                        filterStore.setPageNumber(filterStore.pageNumber + 1);
                        final List<UserProfile> users = await APIService()
                            .getPaginatedUsers(filterStore.pageNumber, {
                          'gender':
                              filterStore.interestedInGender.databaseString,
                          'program': filterStore.program.databaseString,
                          'yearOfJoin': filterStore.yearOfJoin,
                          'name': filterStore.name
                        });
                        print('USERS LENGTH = ${users.length}');
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
