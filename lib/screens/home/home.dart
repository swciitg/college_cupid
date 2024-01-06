import 'package:college_cupid/screens/profile/my_profile_tab.dart';
import 'package:college_cupid/screens/your_crushes/your_crushes_tab.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/widgets/authentication/logout_button.dart';
import '../../widgets/global/nav_icons.dart';
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
  List<Widget> tabs = [
    const HomeTab(),
    const YourCrushesTab(),
    const YourMatches(),
    const MyProfileTab(),
  ];

  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupidColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          systemOverlayStyle: CupidStyles.statusBarStyle,
          backgroundColor: CupidColors.backgroundColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: const [LogoutButton()],
          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('CollegeCupid',
                style: TextStyle(
                  fontFamily: 'SedgwickAve',
                  color: CupidColors.titleColor,
                  fontSize: 32,
                )),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.pink.shade50,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          height: 60,
          elevation: 4,
          shadowColor: Colors.black,
          surfaceTintColor: CupidColors.navBarBackgroundColor,
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: CupidColors.navBarIconColor);
            } else {
              return const IconThemeData(color: Colors.grey);
            }
          }),
        ),
        child: NavigationBar(
          backgroundColor: CupidColors.navBarBackgroundColor,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (i) => setState(() {
            if ((i - _selectedIndex).abs() != 1) {
              _pageController.jumpToPage(i);
            } else {
              _pageController.animateToPage(i,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeIn);
            }
            _selectedIndex = i;
          }),
          destinations: navIcons,
        ),
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: tabs,
        ),
      ),
    );
  }
}
