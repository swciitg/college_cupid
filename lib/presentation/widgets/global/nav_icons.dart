import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';


import 'package:flutter/material.dart';
import 'package:college_cupid/shared/colors.dart';

NavigationDestination buildNavItem({
  required IconData icon,
  required String label,
  required bool isSelected,
}) {
  return NavigationDestination(
    icon: Icon(
      icon,
      size:25,
      color: isSelected ? CupidColors.primaryDark : null,
    ),
    label: label,

  );
}


// Widget buildIcons({

// })

final List<({IconData icon, String label})> navItems = [
  (icon: Icons.person_search_outlined, label: 'Explore'),
  (icon: Icons.record_voice_over_outlined, label: 'Confessions'),
  (icon: Icons.campaign_outlined, label: 'Updates'),
  (icon: Icons.festival_outlined, label: 'Events'),
  (icon: Icons.account_circle_outlined, label: 'Profile'),
];


// List<NavigationDestination> navIcons = [
//   const NavigationDestination(
//     icon: Icon(
//      Icons.person_search_outlined,
//       size: 30,
//     ),
//     label: 'Explore',
//   ),
//   // const NavigationDestination(
//   //   icon: Icon(
//   //     FluentIcons.heart_48_regular,
//   //     size: 30,
//   //   ),
//   //   label: 'Your Crushes',
//   // ),
//   const NavigationDestination(
//     icon: Icon(
//       Icons.record_voice_over_outlined,
//       size: 30,
//     ),
//     label: 'Confessions',
//   ),
//   const NavigationDestination(
//     icon: Icon(
//        Icons.campaign_outlined,
//       size: 30,
//     ),
//     label: 'Updates',
//   ),
//   const NavigationDestination(
//     icon: Icon(
//       Icons.festival_outlined,
//       size: 30,
//     ),
//     label: 'Events',
//   ),
//   // const NavigationDestination(
//   //   icon: Icon(
//   //     FluentIcons.people_48_regular,
//   //     size: 30,
//   //   ),
//   //   label: 'Your Matches',
//   // ),
//   const NavigationDestination(
//     icon: Icon(
//       Icons.account_circle_outlined,
//       size: 30,
//     ),
//     label: 'Profile',
//   ),
// ];

// List<NavigationDestination> filledNavIcons = [
//   const NavigationDestination(
//     icon: Icon(
//       Icons.person_search_outlined,
//       size: 30,
//       color: CupidColors.primaryDark,
//     ),
    
//     label: 'Select Crushes',
//   ),
//   // const NavigationDestination(
//   //   icon: Icon(
//   //     FluentIcons.heart_48_filled,
//   //     size: 30,
//   //     color: CupidColors.primaryDark,
//   //   ),
//   //   label: 'Your Crushes',
//   // ),
//   const NavigationDestination(
//     icon: Icon(
//       Icons.record_voice_over_outlined,
//       size: 30,
//       color: CupidColors.primaryDark, // Purple
//     ),
//     label: 'Confessions',
//   ),
//   const NavigationDestination(
//     icon: Icon(
//       Icons.campaign_outlined,
//       size: 30,
//       color: CupidColors.primaryDark,
//     ),
//     label: 'Updates',
//   ),
//   const NavigationDestination(
//     icon: Icon(
//       Icons.festival_outlined,
//       size: 30,
//       color: CupidColors.primaryDark,
//     ),
//     label: 'Events',
//   ),
//   // const NavigationDestination(
//   //   icon: Icon(
//   //     FluentIcons.people_48_filled,
//   //     size: 30,
//   //     color: CupidColors.primaryDark,
//   //   ),
//   //   label: 'Your Matches',
//   // ),
//   const NavigationDestination(
//     icon: Icon(
//       Icons.account_circle_outlined,
//       size: 30,
//       color: CupidColors.primaryDark,
//     ),
//     label: 'Profile',
//   ),
// ];
