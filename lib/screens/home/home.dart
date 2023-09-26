import 'package:college_cupid/functions/home/nav_icons.dart';
import 'package:college_cupid/screens//add_choices/add_choices_tab.dart';
import 'package:college_cupid/screens//home/home_tab.dart';
import 'package:college_cupid/screens//profile/profile_tab.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  List<Widget> tabs = const [
    HomeTab(),
    AddChoicesTab(),
    ProfileTab(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupidTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'CollegeCupid',
          style: TextStyle(
            color: CupidTheme.titleColor,
            fontFamily: 'SedgwickAve',
            fontSize: 28,
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: CupidTheme.navBarIndicatorColor,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          height: 60,
          iconTheme: MaterialStateProperty.all(
            const IconThemeData(color: CupidTheme.navBarIconColor),
          ),
        ),
        child: NavigationBar(
          elevation: 4,
          backgroundColor: CupidTheme.navBarBackgroundColor,
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
