import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class ProfileOptionsBottomSheet extends StatefulWidget {
  final String userEmail;
  const ProfileOptionsBottomSheet({required this.userEmail, super.key});

  @override
  State<ProfileOptionsBottomSheet> createState() =>
      _ProfileOptionsBottomSheetState();
}

class _ProfileOptionsBottomSheetState extends State<ProfileOptionsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: CupidColors.backgroundColor,
        ),
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {},
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FluentIcons.flag_24_regular,
                      color: CupidColors.titleColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Report User',
                      style: CupidStyles.textButtonStyle,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
