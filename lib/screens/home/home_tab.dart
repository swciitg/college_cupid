import 'package:college_cupid/screens/profile/profile_list.dart';
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
            padding: const EdgeInsets.all(20.0),
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
                    color: Colors.white, // Background color for the TextField
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none, // No border for the TextField
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.clear),
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
              Text('Filter '),
              IconButton(
                icon: Image.asset('assets/icons/filter.png'),
                onPressed: () {
                  // Handle the filter button press
                },
              ),
            ],
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(20),
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
                                  builder: (context) => ProfileList()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/icons/crush.png'))),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: SizedBox()),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
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
}
