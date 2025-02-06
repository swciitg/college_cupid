import 'package:college_cupid/presentation/screens/home/home_tab.dart';
import 'package:college_cupid/presentation/screens/profile/view_profile/user_profile_screen.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/heart_shape.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/heart_state.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/mbti_test_screen.dart';
import 'package:college_cupid/presentation/screens/your_crushes/your_crushes_tab.dart';
import 'package:college_cupid/presentation/screens/your_matches/your_matches_tab.dart';
import 'package:college_cupid/presentation/widgets/global/nav_icons.dart';
import 'package:college_cupid/presentation/widgets/ui/college_cupid_upgrader.dart';
import 'package:college_cupid/shared/assets.dart';
import 'package:college_cupid/shared/colors.dart';
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
        ref.read(pageViewProvider.notifier).getInitialProfiles();
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
    final size = MediaQuery.sizeOf(context);
    return CollegeCupidUpgrader(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: CupidColors.backgroundColor,
          ),
          child: Stack(
            children: [
              ..._heartShapes(
                HeartState(
                  size: 200,
                  left: -60,
                  bottom: size.height * 0.25,
                ),
                HeartState(
                  size: 200,
                  right: 75,
                  bottom: size.height * 0.09,
                ),
                HeartState(
                  size: 180,
                  right: -50,
                  top: size.height * 0.25,
                ),
              ),
              SizedBox(
                height: size.height,
                width: size.width,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  bottomNavigationBar: NavigationBarTheme(
                    data: NavigationBarThemeData(
                      backgroundColor: Colors.transparent,
                      indicatorColor: Colors.transparent,
                      labelBehavior:
                          NavigationDestinationLabelBehavior.alwaysHide,
                      height: 60,
                      elevation: 0,
                      shadowColor: Colors.black,
                      surfaceTintColor: CupidColors.navBarBackgroundColor,
                      iconTheme: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return const IconThemeData(
                              color: CupidColors.secondaryColor);
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
                      destinations: List.generate(4, (index) {
                        return _selectedIndex == index
                            ? filledNavIcons[index]
                            : navIcons[index];
                      }),
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
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _heartShapes(
      HeartState yellow, HeartState blue, HeartState pink) {
    return [
      AnimatedPositioned(
        duration: const Duration(milliseconds: 2000),
        curve: Curves.easeInOut,
        top: yellow.top,
        right: yellow.right,
        bottom: yellow.bottom,
        left: yellow.left,
        child: HeartShape(
          size: yellow.size,
          asset: CupidIcons.heartOutline,
          color: const Color(0x99EAE27A),
        ),
      ),
      AnimatedPositioned(
        duration: const Duration(milliseconds: 2000),
        curve: Curves.easeInOut,
        top: blue.top,
        right: blue.right,
        bottom: blue.bottom,
        left: blue.left,
        child: HeartShape(
          size: blue.size,
          asset: CupidIcons.heartOutline,
          color: const Color(0x99A8CEFA),
        ),
      ),
      AnimatedPositioned(
        duration: const Duration(milliseconds: 2000),
        curve: Curves.easeInOut,
        top: pink.top,
        right: pink.right,
        bottom: pink.bottom,
        left: pink.left,
        child: HeartShape(
          size: pink.size,
          asset: CupidIcons.heartOutline,
          color: const Color(0x99F9A8D4),
        ),
      ),
    ];
  }
}
