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
      FluentIcons.heart_48_filled,
      size: 30,
    ),
    label: 'Your Crushes',
  ),
  const NavigationDestination(
    icon: Icon(
      FluentIcons.people_48_filled,
      size: 30,
    ),
    label: 'Your Matches',
  ),
  const NavigationDestination(
    icon: Icon(
      FluentIcons.person_48_filled,
      size: 30,
    ),
    label: 'Profile',
  ),
];
