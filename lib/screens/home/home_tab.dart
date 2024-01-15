import 'dart:async';
import 'package:college_cupid/stores/filter_store.dart';
import 'package:college_cupid/stores/page_view_store.dart';
import 'package:college_cupid/widgets/global/custom_loader.dart';
import 'package:college_cupid/widgets/home/filter_bottom_sheet.dart';
import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/widgets/home/profile_view.dart';
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
    filterStore.resetStore();
    pageViewStore.resetStore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    filterStore = context.read<FilterStore>();
    pageViewStore = context.read<PageViewStore>();
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: CupidColors.titleColor,
                    ),
                  ),
                  child: TextFormField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (value) {
                      filterStore.setName(_searchController.text);
                    },
                    onChanged: (value) {
                      if (timer != null) timer!.cancel();
                      timer = Timer(const Duration(seconds: 1), () {
                        filterStore.setName(value);
                        pageViewStore.resetStore();
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
                    filterStore.setName('');
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
                        color: CupidColors.backgroundColor,
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
          Observer(builder: (_) {
            pageViewStore.resetStore();
            return FutureBuilder(
              future: APIService().getPaginatedUsers(0, {
                //don't want it to be triggered when pageNumber is changed
                'gender': filterStore.interestedInGender.databaseString,
                'program': filterStore.program.databaseString,
                'yearOfJoin': filterStore.yearOfJoin,
                'name': filterStore.name,
              }),
              builder: (futureBuilderContext, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (snapshot.hasData) {
                  return ProfileView(
                    pageController: _pageController,
                    userProfiles: snapshot.data!,
                  );
                } else {
                  return const CustomLoader();
                }
              },
            );
          }),
        ],
      ),
    );
  }
}
