import 'package:flutter/material.dart';

const List<NavigationDestination> navIcons = [
  NavigationDestination(
    icon: Icon(
      Icons.home_rounded,
      size: 32,
    ),
    label: 'Home',
  ),
  NavigationDestination(icon: Icon(Icons.edit_rounded), label: 'Add Choices'),
  NavigationDestination(
    icon: Icon(
      Icons.person_rounded,
      size: 32,
    ),
    label: 'Profile',
  )
];
