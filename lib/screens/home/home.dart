import 'package:college_cupid/screens/account/acc.dart';

import '../../functions/home/nav_icons.dart';
import '../add_choices/add_choices_tab.dart';
import './home_tab.dart';
import '../profile/profile_tab.dart';
import '../../shared/colors.dart';
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
    Accounttab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupidColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'CollegeCupid',
          style: TextStyle(
            color: CupidColors.titleColor,
            fontFamily: 'SedgwickAve',
            fontSize: 28,
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.pink.shade50,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          height: 60,
          iconTheme: MaterialStateProperty.all(
            const IconThemeData(color: CupidColors.navBarIconColor),
          ),
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
        //fixed code
      ),
    );
  }
}
