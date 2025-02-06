import 'package:college_cupid/presentation/screens/home/home_tab.dart';
import 'package:college_cupid/presentation/screens/profile/view_profile/user_profile_screen.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/mbti_test_screen.dart';
import 'package:college_cupid/presentation/screens/your_crushes/your_crushes_tab.dart';
import 'package:college_cupid/presentation/screens/your_matches/your_matches_tab.dart';
import 'package:college_cupid/presentation/widgets/global/app_title.dart';
import 'package:college_cupid/presentation/widgets/global/nav_icons.dart';
import 'package:college_cupid/presentation/widgets/home/drawer_widget.dart';
import 'package:college_cupid/presentation/widgets/ui/college_cupid_upgrader.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/page_view_controller.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userProvider).myProfile!;
      if (user.personalityType != null) {
        ref.read(pageViewProvider.notifier).getInitialProfiles(context);
        return;
      }
      _showMBTITest(context);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showMBTITest(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => const ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        child: Padding(
          padding: EdgeInsets.only(top: kToolbarHeight),
          child: MbtiTestScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userController = ref.watch(userProvider);

    return CollegeCupidUpgrader(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          endDrawer: const DrawerWidget(),
          appBar: _selectedIndex == 3
              ? PreferredSize(
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
                )
              : null,
          backgroundColor: Colors.white,
          bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: Colors.pink.shade50,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              height: 60,
              elevation: 4,
              shadowColor: Colors.black,
              surfaceTintColor: CupidColors.navBarBackgroundColor,
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
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
          body: SafeArea(
            child: SizedBox.expand(
              child: PageView(
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
                    userProfile: userController.myProfile!,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
