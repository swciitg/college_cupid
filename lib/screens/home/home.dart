import 'package:college_cupid/screens/profile/my_profile_tab.dart';
import 'package:college_cupid/screens/your_crushes/your_crushes_tab.dart';
import 'package:college_cupid/splash.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter/services.dart';
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
    YourCrushesTab(),
    const YourMatches(),
    const MyProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupidColors.backgroundColor,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: CupidColors.backgroundColor,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        backgroundColor: CupidColors.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                NavigatorState nav = Navigator.of(context);
                bool cleared = await LoginStore.logout();
                if (cleared) {
                  nav.pushNamedAndRemoveUntil(
                      SplashScreen.id, (route) => false);
                }
              },
              icon: const Icon(
                Icons.logout_rounded,
                color: CupidColors.pinkColor,
              ))
        ],
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
