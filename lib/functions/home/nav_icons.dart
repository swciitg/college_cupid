import 'package:flutter/material.dart';

List<NavigationDestination> navIcons = [
  const NavigationDestination(
    //icon: Image.asset('assets/icons/slides.png'), label: 'slides'),
    icon: Icon(
      Icons.search_rounded,
      size: 30,
    ),
    label: 'Select Crushes',
  ),
  const NavigationDestination(
    //icon: Image.asset('assets/icons/likelike(1).png'), label: 'check likes'),
    icon: Icon(
      Icons.favorite,
      size: 30,
    ),
    label: 'Your Crushes',
  ),
  const NavigationDestination(
    // icon: Image.asset('assets/icons/phone.png'), label: 'recent calls '),
    icon: Icon(
      Icons.family_restroom_rounded,
      size: 30,
    ),
    label: 'Your Matches',
  ),
  const NavigationDestination(
    //icon: Image.asset('assets/icons/acc.png'), label: 'your account'),
    icon: Icon(
      Icons.person_rounded,
      size: 30,
    ),
    label: 'Profile',
  ),
];
