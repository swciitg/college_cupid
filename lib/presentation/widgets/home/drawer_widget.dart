import 'package:college_cupid/functions/launchers.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/presentation/widgets/authentication/logout_button.dart';
import 'package:college_cupid/presentation/widgets/global/cupid_text_button.dart';
import 'package:college_cupid/presentation/widgets/global/deactivate_account_alert.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/stores/user_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final user = ref.read(userProvider).myProfile!;
    return Container(
      width: screenWidth * 0.55,
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TODO: App Logo
                  // const Divider(),
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
                    },
                  ),
                  CupidTextButton(
                    text: 'About us',
                    onPressed: () async {
                      try {
                        await launchURL(host: 'swc.iitg.ac.in');
                      } catch (e) {
                        showSnackBar(e.toString());
                      }
                    },
                  ),
                  // TODO: Deactivate account
                  CupidTextButton(
                    text:
                        '${user.deactivated ? "Activate" : "Deactivate"} account',
                    onPressed: () async {
                      context.pop();
                      await showDialog(
                        context: context,
                        builder: (context) => DeactivateAccountAlert(
                          activateBack: user.deactivated,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Image.asset(
                'assets/images/SWC_Logo_black.png',
              ),
            ),
            const LogoutButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
