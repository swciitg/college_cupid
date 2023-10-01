import 'package:college_cupid/screens/your_crushes/your_crushes_tab.dart';
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
    YourCrushesTab(),
    AddChoicesTab(),
    ProfileTab(),
    Accounttab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupidColors.backgroundColor,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: CupidColors.navBarIndicatorColor,
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
