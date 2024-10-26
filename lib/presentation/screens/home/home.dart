import 'package:college_cupid/presentation/screens/home/home_tab.dart';
import 'package:college_cupid/presentation/widgets/ui/college_cupid_upgrader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/colors.dart';

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return CollegeCupidUpgrader(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: const <Widget>[
            HomeTab(),
            Center(child: Text("Profile", style: TextStyle(fontSize: 24))),
            Center(child: Text("Messeges", style: TextStyle(fontSize: 24))),
            Center(child: Text("Settings", style: TextStyle(fontSize: 24))),
          ],
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _selectedIndex == 0
                          ? CupidColors.navBarSelectedColor
                          : CupidColors.navBarUnseleectedColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 5,
                        ),
                      ]),
                  padding: const EdgeInsets.all(2),
                  child: SvgPicture.asset(
                    "assets/icons/cupid.svg",
                    height: 20,
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 1
                    ? ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                            CupidColors.navBarSelectedColor, BlendMode.srcIn),
                        child: Image.asset("assets/images/profile.png",
                            height: 24),
                      )
                    : Image.asset("assets/images/profile.png", height: 24),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 2
                    ? ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                            CupidColors.navBarSelectedColor, BlendMode.srcIn),
                        child: Image.asset("assets/images/message.png",
                            height: 24),
                      )
                    : Image.asset("assets/images/message.png", height: 24),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 3
                    ? ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                            CupidColors.navBarSelectedColor, BlendMode.srcIn),
                        child: Image.asset("assets/images/settings.png",
                            height: 24),
                      )
                    : Image.asset("assets/images/settings.png", height: 24),
                label: '',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            elevation: 2,
          ),
        ),
      ),
    );
  }
}
