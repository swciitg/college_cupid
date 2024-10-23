import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class CollegeCupidUpgraderMessages extends UpgraderMessages {
  @override
  String get title => 'CollegeCupid Update Available';
  @override
  String get body =>
      'CollegeCupid v{{currentAppStoreVersion}} is now available. You are on a previous version - v{{currentInstalledVersion}}';
}

class CollegeCupidUpgrader extends StatelessWidget {
  final Widget child;
  const CollegeCupidUpgrader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          dialogTheme: const DialogTheme(
            backgroundColor: CupidColors.backgroundColor,
            titleTextStyle: CupidStyles.pageHeadingStyle,
            contentTextStyle: CupidStyles.normalTextStyle,
          ),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(textStyle: WidgetStateProperty.all(CupidStyles.textButtonStyle)))),
      child: UpgradeAlert(
          upgrader: Upgrader(
            countryCode: 'IN',
            durationUntilAlertAgain: const Duration(hours: 1),
            messages: CollegeCupidUpgraderMessages(),
          ),
          child: child),
    );
  }
}
