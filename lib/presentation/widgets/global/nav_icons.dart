import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';

NavigationDestination buildNavItem({
  required IconData icon,
  required String label,
  required bool isSelected,
}) {
  return NavigationDestination(
    icon: Icon(
      icon,
      size: 25,
      color: isSelected ? CupidColors.primaryDark : null,
    ),
    label: label,
  );
}

final List<({IconData icon, String label})> navItems = [
  (icon: Icons.person_search_outlined, label: 'Explore'),
  (icon: Icons.record_voice_over_outlined, label: 'Confessions'),
  (icon: Icons.campaign_outlined, label: 'Updates'),
  (icon: Icons.festival_outlined, label: 'Events'),
  (icon: Icons.account_circle_outlined, label: 'Profile'),
];
