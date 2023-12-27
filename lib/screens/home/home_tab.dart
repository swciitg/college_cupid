import 'dart:async';

import 'package:college_cupid/models/user_profile.dart';
import 'package:college_cupid/widgets/home/filter_bottom_sheet.dart';
import 'package:college_cupid/screens/profile/user_profile_screen.dart';
import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/widgets/home/profile_card.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  final defaultPicUrl =
      "https://hips.hearstapps.com/hmg-prod/images/cute-cat-photos-1593441022.jpg?crop=0.670xw:1.00xh;0.167xw,0&resize=640:*";

  Future<List<UserProfile>> getUserProfilesFuture =
      APIService().getAllOtherUsers();

  Timer? timer;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserProfilesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          return Column(
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
                            setState(() {
                              getUserProfilesFuture = APIService()
                                  .getAllSearchedUserProfiles(value);
                            });
                          }
                        },
                        onChanged: (value) {
                          if (timer != null) timer!.cancel();
                          timer = Timer(const Duration(seconds: 1), () {
                            print('timer');
                            if (mounted) {
                              setState(() {
                                getUserProfilesFuture = APIService()
                                    .getAllSearchedUserProfiles(value);
                              });
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search),
                          border:
                              InputBorder.none, // No border for the TextField
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
                mainAxisAlignment:
                    MainAxisAlignment.end, // Align the row to the right
                children: [
                  const Text('Filter '),
                  IconButton(
                    icon: Image.asset('assets/icons/filter.png'),
                    onPressed: () {
                      showFilterSheet(context);
                    },
                  ),
                ],
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      sliver: SliverGrid.count(
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 12,
                        crossAxisCount: 2,
                        children: snapshot.data!.map((user) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                // isMine = false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserProfileScreen(
                                            isMine: false,
                                            userProfile: user,
                                          )));
                            },
                            child: ProfileCard(
                              name: user.name,
                              profilePicUrl: user.profilePicUrl.isNotEmpty
                                  ? user.profilePicUrl
                                  : defaultPicUrl,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Future<dynamic> showFilterSheet(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return const FilterBottomSheet();
        });
  }
}
