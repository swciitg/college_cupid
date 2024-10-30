import 'dart:async';

import 'package:college_cupid/presentation/screens/profile_setup/profilesetup.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/presentation/widgets/home/filter_bottom_sheet.dart';
import 'package:college_cupid/presentation/widgets/home/profile_view.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/filter_store.dart';
import 'package:college_cupid/stores/page_view_store.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();
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
    final userProfileRepo = ref.read(userProfileRepoProvider);
    filterStore = context.read<FilterStore>();
    pageViewStore = context.read<PageViewStore>();
    return Stack(
      children: [

        Builder(builder: (context) {
          return const Positioned(
              top: 50,
              right: 0,
              child: HeartWidget(
                  size: 200,
                  asset: "assets/icons/heart_outline.svg",
                  color: Color(0x99FBA8AA)));
        }),
        Builder(builder: (context) {
          return Positioned(
              left: -75,
              bottom: MediaQuery.of(context).size.height * 0.27,
              child: const HeartWidget(
                  size: 200,
                  asset: "assets/icons/heart_outline.svg",
                  color: Color(0x99A8CEFA)));
        }),
        Builder(builder: (context) {
          return Positioned(
              right: -40,
              bottom: MediaQuery.of(context).size.height * 0.05,
              child: const HeartWidget(
                  size: 200,
                  asset: "assets/icons/heart_outline.svg",
                  color: Color(0x99EAE27A)));
        }),


        SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0,top:10, right: 20),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CupidColors.glassWhite,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black87.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(2),
                    child: InkWell(
                      onTap: (){
                      },
                      child: SvgPicture.asset(
                        "assets/icons/cupid.svg",
                        height: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: CupidColors.glassWhite, // Background color
                        borderRadius:  const BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (value) {
                          filterStore.setName(value);
                        },
                        onChanged: (value) {
                          if (timer != null) timer!.cancel();
                          timer = Timer(const Duration(seconds: 1), () {
                            filterStore.setName(value);
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          suffixIcon: Container(
                            decoration: const BoxDecoration(
                                color: Color(0x4DEAE27A),
                              borderRadius: BorderRadius.only(
                                topRight:Radius.circular(15),
                                bottomRight: Radius.circular(15)
                              )
                            ),
                            child: const Icon(
                              Icons.search,
                              color: CupidColors.textColorBlack, // Suffix icon color
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: CupidColors.blackColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            /*Row(
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
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (_) {
                            return const FilterBottomSheet();
                          });
                    },
                  ),
                ),
              ],
            ),*/
            Observer(builder: (_) {
              pageViewStore.resetStore();
              return FutureBuilder(
                future: userProfileRepo.getPaginatedUsers(0, {
                  //don't want it to be triggered when pageNumber is changed
                  'gender': filterStore.interestedInGender.databaseString,
                  'program': filterStore.program.databaseString,
                  'yearOfJoin': filterStore.yearOfJoin,
                  'name': filterStore.name,
                }),
                builder: (futureBuilderContext, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text(
                      'Some Error Occurred!\nPlease try again!',
                      textAlign: TextAlign.center,
                      style: CupidStyles.lightTextStyle,
                    ));
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
      )
      ],
    );
  }
}
