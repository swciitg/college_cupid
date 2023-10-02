import 'dart:async';
import 'package:college_cupid/screens/your_crushes/your_crushes_tab.dart';
import 'package:college_cupid/screens/account/acc.dart';
import '../../functions/home/nav_icons.dart';
import '../add_choices/add_choices_tab.dart';
import './home_tab.dart';
import '../your_matches/your_matches.dart';
import '../../shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  List<Widget> tabs = [
    HomeTab(),
    YourCrushesTab(),
    AddChoicesTab(),
    Timer(),
    Accounttab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupidColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.pink, // Change this to pink
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('CollegeCupid',
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
