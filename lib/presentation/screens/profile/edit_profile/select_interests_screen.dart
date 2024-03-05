import 'package:college_cupid/presentation/widgets/profile/interests/display_interests.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

class SelectInterestsScreen extends StatefulWidget {
  const SelectInterestsScreen({super.key});

  static String id = '/selectInterests';

  @override
  State<SelectInterestsScreen> createState() => _SelectInterestsScreenState();
}

class _SelectInterestsScreenState extends State<SelectInterestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: CupidStyles.statusBarStyle,
        foregroundColor: CupidColors.titleColor,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title:
            const Text("Select Interests", style: CupidStyles.pageHeadingStyle),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: CupidColors.titleColor,
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
      body: const SingleChildScrollView(
        child: DisplayInterests(),
      ),
    );
  }
}
