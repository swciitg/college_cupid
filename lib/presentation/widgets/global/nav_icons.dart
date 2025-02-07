import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

List<NavigationDestination> navIcons = [
  const NavigationDestination(
    icon: Icon(
      FluentIcons.search_48_filled,
      size: 30,
    ),
    label: 'Select Crushes',
  ),
  const NavigationDestination(
    icon: Icon(
      FluentIcons.heart_48_regular,
      size: 30,
    ),
    label: 'Your Crushes',
  ),
  const NavigationDestination(
    icon: Icon(
      FluentIcons.people_48_regular,
      size: 30,
    ),
    label: 'Your Matches',
  ),
  const NavigationDestination(
    icon: Icon(
      FluentIcons.person_48_regular,
      size: 30,
    ),
    label: 'Profile',
  ),
];

List<NavigationDestination> filledNavIcons = [
  const NavigationDestination(
    icon: Icon(
      FluentIcons.search_48_filled,
      size: 30,
      color: CupidColors.cupidBlue,
    ),
    label: 'Select Crushes',
  ),
  const NavigationDestination(
    icon: Icon(
      FluentIcons.heart_48_filled,
      size: 30,
      color: CupidColors.cupidGreen,
    ),
    label: 'Your Crushes',
  ),
  const NavigationDestination(
    icon: Icon(
      FluentIcons.people_48_filled,
      size: 30,
      color: CupidColors.cupidPeach,
    ),
    label: 'Your Matches',
  ),
  const NavigationDestination(
    icon: Icon(
      FluentIcons.person_48_filled,
      size: 30,
      color: CupidColors.cupidYellow,
    ),
    label: 'Profile',
  ),
];
