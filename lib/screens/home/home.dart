import 'package:college_cupid/screens/your_crushes/your_crushes_tab.dart';
import '../../functions/home/nav_icons.dart';
import './home_tab.dart';
import '../your_matches/your_matches_tab.dart';
import '../../shared/colors.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static String id = '/home';

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  List<Widget> tabs = [
    const HomeTab(),
    const YourCrushesTab(),
    const YourMatches(),
    // const ProfileTab(isMine: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupidColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('CollegeCupid',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
            )),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.pink.shade50,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          height: 60,
          iconTheme: MaterialStateProperty.resolveWith((states) {
            // Change icon color based on the tab being active or inactive
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: CupidColors.navBarIconColor);
            } else {
              return const IconThemeData(color: Colors.grey);
            }
          }),
        ),
        child: NavigationBar(
          elevation: 4,
          backgroundColor: CupidColors.navBarBackgroundColor,
          selectedIndex: index,
          onDestinationSelected: (i) => setState(() {
            index = i;
          }),
          destinations: navIcons,
        ),
      ),
      body: SafeArea(
        child: tabs[index],
      ),
    );
  }
}
