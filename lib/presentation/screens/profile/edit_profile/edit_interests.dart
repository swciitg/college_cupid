import 'package:college_cupid/presentation/widgets/profile/interests/display_interests.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

class EditInterests extends StatelessWidget {
  const EditInterests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 8),
            DisplayInterests(),
            SizedBox(height: kBottomNavigationBarHeight),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () async {
          navigatorKey.currentState?.pop();
        },
      ),
      scrolledUnderElevation: 0,
      title: const Text(
        "Edit Interests",
        style: CupidStyles.headingStyle,
      ),
      centerTitle: false,
    );
  }
}
