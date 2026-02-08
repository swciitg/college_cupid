import 'package:college_cupid/presentation/screens/home/home_tab.dart';
import 'package:college_cupid/presentation/screens/confessions/confessions_screen.dart';
import 'package:college_cupid/presentation/screens/profile/view_profile/user_profile_screen.dart';
import 'package:college_cupid/presentation/screens/profile_setup/profile_setup.dart';
import 'package:college_cupid/presentation/screens/updates/updates_screen.dart';
import 'package:college_cupid/presentation/screens/events/events_screen.dart';
import 'package:college_cupid/presentation/widgets/global/nav_icons.dart';
import 'package:college_cupid/presentation/widgets/ui/college_cupid_upgrader.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/page_view_controller.dart';
import 'package:college_cupid/stores/home_tab_provider.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        ref.read(pageViewProvider.notifier).getInitialProfiles();
        return;
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userController = ref.watch(userProvider);
    ref.listen<int>(homeTabIndexProvider, (previous, next) {
      if (next != _selectedIndex) {
        _pageController.jumpToPage(next);
        setState(() {
          _selectedIndex = next;
        });
      }
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: CupidStyles.edgeToEdgeSystemUI,
      child: CollegeCupidUpgrader(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: CupidColors.backgroundColor,
            bottomNavigationBar: _navBar(),
            body: Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.4, 1.0],
                      colors: [
                        CupidColors.navBarIconColor.withValues(alpha: 0.3),
                        CupidColors.navBarIconColor.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  top: true,
                  bottom: false,
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
                        // const YourCrushesTab(),
                        const ConfessionsScreen(),
                        const UpdatesScreen(),
                        const EventsScreen(),
                        //const YourMatches(),
                        UserProfileScreen(
                          isMine: true,
                          userProfile: userController.myProfile!,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  NavigationBarTheme _navBar() {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          if (states.contains(WidgetState.selected)) {
            // A → selected
            return CupidTextStyles.label3
                .copyWith(color: CupidColors.primaryDark, fontSize: 11);
          }
          // B → unselected
          return CupidTextStyles.label3
              .copyWith(color: CupidColors.keyboardTextLowEm, fontSize: 11);
        }),
        height: 60,
        elevation: 0,
        shadowColor: Colors.black,
        backgroundColor: CupidColors.navBarBackgroundColor,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: CupidColors.secondaryColor);
          } else {
            return const IconThemeData(color: Colors.grey);
          }
        }),
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(color: CupidColors.offWhiteColor, width: 2)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
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
            labelTextStyle:
                WidgetStateProperty.resolveWith<TextStyle>((states) {
              if (states.contains(WidgetState.selected)) {
                // A → selected
                return CupidTextStyles.label3
                    .copyWith(color: CupidColors.primaryDark, fontSize: 10);
              }
              // B → unselected
              return CupidTextStyles.label3
                  .copyWith(color: CupidColors.keyboardTextLowEm, fontSize: 10);
            }),
            destinations: List.generate(navItems.length, (index) {
              final item = navItems[index];
              return Container(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.symmetric(
                    horizontal: _selectedIndex == index ? 4 : 0),
                decoration: _selectedIndex == index
                    ? ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            spreadRadius: 0,
                            offset: Offset(0, 6),
                          ),
                        ],
                      )
                    : null,
                child: buildNavItem(
                  icon: item.icon,
                  label: item.label,
                  isSelected: _selectedIndex == index,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
