import 'dart:async';
import 'package:college_cupid/models/user_profile.dart';
import 'package:college_cupid/stores/filter_store.dart';
import 'package:college_cupid/stores/page_view_store.dart';
import 'package:college_cupid/widgets/global/custom_loader.dart';
import 'package:college_cupid/widgets/home/filter_bottom_sheet.dart';
import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/widgets/home/profile_card.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
  Timer? timer;
  late FilterStore filterStore;
  late PageViewStore pageViewStore;

  @override
  void dispose() {
    _searchController.dispose();
    filterStore.clearFilters();
    pageViewStore.resetStore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    filterStore = context.read<FilterStore>();
    pageViewStore = context.read<PageViewStore>();
    final double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Filters'),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                child: GestureDetector(
                  child: Container(
                      decoration: BoxDecoration(
                        color: CupidColors.pinkishGreyColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Center(
                          child: Icon(
                            FluentIcons.filter_20_filled,
                            size: 20,
                            color: CupidColors.pinkColor,
                          ),
                        ),
                      )),
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (_) {
                          return const FilterBottomSheet();
                        });
                  },
                ),
              ),
            ],
          ),
          Observer(
            builder: (_) {
              print("Observer Builder called");
              return FutureBuilder(
                future: APIService().getPaginatedUsers(pageViewStore.pageNumber, {
                  'gender': filterStore.interestedInGender.databaseString,
                  'program': filterStore.program.databaseString,
                  'yearOfJoin': filterStore.yearOfJoin,
                  'name': filterStore.name,
                }),
                builder: (context, snapshot) {
                  print("Future Builder called");

                  if (snapshot.hasData == false) {
                    return const CustomLoader();
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  return Observer(
                    builder: (_) {
                      if(pageViewStore.homeTabProfileList.isEmpty){
                        pageViewStore.addHomeTabProfiles(snapshot.data!);
                      }
                      print("pages.length = ${pageViewStore.homeTabProfileList.length}");
                      pageViewStore.setIsLastPage(snapshot.data!.length < 10);
                      return SizedBox(
                        height: screenHeight*0.65,
                        child: PageView(
                          allowImplicitScrolling: false,
                          onPageChanged: (value) async {
                            print("pg number: ${pageViewStore.pageNumber}");
                            print("index: $value");

                            if (pageViewStore.isLastPage) return;
                            if (pageViewStore.homeTabProfileList.length - value <= 4) {
                              pageViewStore.setPageNumber(pageViewStore.pageNumber + 1);
                              print("here");
                              final List<UserProfile> users = await APIService()
                                  .getPaginatedUsers(pageViewStore.pageNumber, {
                                'gender':
                                filterStore.interestedInGender.databaseString,
                                'program': filterStore.program.databaseString,
                                'yearOfJoin': filterStore.yearOfJoin,
                                'name': filterStore.name
                              });
                              print("users.length = ${users.length}");
                              if (users.length < 10) pageViewStore.setIsLastPage(true);
                              pageViewStore.addHomeTabProfiles(users);
                              print("pages.length = ${pageViewStore.homeTabProfileList.length}");
                            }
                          },
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          children: pageViewStore.homeTabProfileList.map((element) => ProfileCard(user: element)).toList(),
                        ),
                      );
                    }
                  );
                },
              );
            }
          ),
        ],
      ),
    );
  }
}
