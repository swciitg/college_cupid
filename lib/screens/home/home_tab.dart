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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: APIService().getAllOtherUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return const Center(
              child: Text('Loading'),
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
                  alignment: Alignment
                      .centerRight, // Align the clear button to the right
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: CupidColors.titleColor, // Highlight color
                        ),
                        color: CupidColors
                            .backgroundColor, // Background color for the TextField
                      ),
                      child: TextFormField(
                        controller: _searchController,
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
                        // Handle the clear button press
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
                              profilePicUrl: user.profilePicUrl,
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
