import 'package:flutter/material.dart';

const List<NavigationDestination> navIcons = [
  NavigationDestination(
    icon: Icon(
      Icons.home_rounded,
      size: 32,
    ),
    label: 'Home',
  ),
  //Todo replace with original navigation icon
  NavigationDestination(icon:Icon(Icons.heart_broken) , label: 'Likes'),
  NavigationDestination(icon: Icon(Icons.edit_rounded), label: 'Add Choices'),
  NavigationDestination(
    icon: Icon(
      Icons.person_rounded,
      size: 32,
    ),
    label: 'Profile',
  )
];
