import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/screens/home/home_tab.dart';
import 'package:college_cupid/presentation/screens/profile/view_profile/user_profile_screen.dart';
import 'package:college_cupid/presentation/screens/your_crushes/your_crushes_tab.dart';
import 'package:college_cupid/presentation/screens/your_matches/your_matches_tab.dart';
import 'package:college_cupid/presentation/widgets/global/app_title.dart';
import 'package:college_cupid/presentation/widgets/global/nav_icons.dart';
import 'package:college_cupid/presentation/widgets/home/drawer_widget.dart';
import 'package:college_cupid/presentation/widgets/ui/college_cupid_upgrader.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/common_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    final commonStore = context.read<CommonStore>();

    return CollegeCupidUpgrader(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          endDrawer: const DrawerWidget(),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              foregroundColor: CupidColors.pinkColor,
              systemOverlayStyle: CupidStyles.statusBarStyle,
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              centerTitle: false,
              title: const AppTitle(),
            ),
          ),
          backgroundColor: Colors.white,
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
                  return const IconThemeData(
                      color: CupidColors.navBarIconColor);
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
            child: Observer(builder: (_) {
              return PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: [
                  const HomeTab(),
                  const YourCrushesTab(),
                  const YourMatches(),
                  UserProfileScreen(
                    isMine: true,
                    userProfile: UserProfile.fromJson(commonStore.myProfile),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
