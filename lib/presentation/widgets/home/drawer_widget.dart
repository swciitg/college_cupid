import 'package:college_cupid/functions/launchers.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/presentation/widgets/authentication/logout_button.dart';
import 'package:college_cupid/presentation/widgets/global/app_title.dart';
import 'package:college_cupid/presentation/widgets/global/cupid_text_button.dart';
import 'package:college_cupid/routing/app_router.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.65,
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: AppTitle()),
                  const Divider(),
                  CupidTextButton(
                    text: 'Blocked Users',
                    onPressed: () {
                      context.pop();
                      context.pushNamed(AppRoutes.blockedUserListScreen.name);
                    },
                  ),
                  CupidTextButton(
                      text: 'Terms of use',
                      onPressed: () async {
                        try {
                          await launchURL(
                            host: 'swc.iitg.ac.in',
                            path: '/collegeCupid/terms',
                          );
                        } catch (e) {
                          showSnackBar(e.toString());
                        }
                      }),
                  CupidTextButton(
                      text: 'About us',
                      onPressed: () async {
                        try {
                          await launchURL(host: 'swc.iitg.ac.in');
                        } catch (e) {
                          showSnackBar(e.toString());
                        }
                      }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Image.asset(
                'assets/images/SWC_Logo_black.png',
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: LogoutButton(),
            ),
          ],
        ),
      ),
    );
  }
}
