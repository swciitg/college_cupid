import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/utils/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/app_router.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupidColors.backgroundColor,
      body: Stack(
        children: [
          // 1. The Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_bg.png',
              fit: BoxFit.cover, // This ensures the image covers the entire screen
            ),
          ),
          // 2. Your UI Content
          Column(
            children: [
              const Spacer(), // Replaces Expanded(child: Container()) for cleaner code
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                child: CommonWidgets.button(
                  title: 'Log in with Outlook',
                  onTap: () {
                    context.goNamed(AppRoutes.loginWebview.name);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
