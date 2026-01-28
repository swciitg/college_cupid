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
      FluentIcons.chat_24_regular,
      size: 30,
    ),
    label: 'Confessions',
  ),
  const NavigationDestination(
    icon: Icon(
      FluentIcons.speaker_2_24_regular,
      size: 30,
    ),
    label: 'Updates',
  ),
  const NavigationDestination(
    icon: Icon(
      FluentIcons.calendar_star_24_regular,
      size: 30,
    ),
    label: 'Events',
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
      FluentIcons.chat_24_filled,
      size: 30,
      color: Color(0xFF8B5CF6), // Purple
    ),
    label: 'Confessions',
  ),
  const NavigationDestination(
    icon: Icon(
      FluentIcons.speaker_2_24_filled,
      size: 30,
      color: CupidColors.cupidPurple,
    ),
    label: 'Updates',
  ),
  const NavigationDestination(
    icon: Icon(
      FluentIcons.calendar_star_24_filled,
      size: 30,
      color: Color(0xFF8B5CF6),
    ),
    label: 'Events',
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
