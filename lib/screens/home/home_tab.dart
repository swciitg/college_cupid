import 'package:college_cupid/screens/home/filter_bottom_sheet.dart';
import 'package:college_cupid/screens/profile/profile_list.dart';
import 'package:college_cupid/screens/profile/profile_tab.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
            child: Stack(
              alignment:
                  Alignment.centerRight, // Align the clear button to the right
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Colors.pink, // Highlight color
                    ),
                    color: CupidColors.backgroundColor, // Background color for the TextField
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none, // No border for the TextField
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
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 12,
                    crossAxisCount: 2,
                    children: List.generate(30, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            // isMine = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfileTab(isMine: false)));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/icons/crush.png'))),
                          child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: SizedBox()),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    "Name",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                )
                              ]),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
