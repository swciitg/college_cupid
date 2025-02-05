import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/presentation/widgets/global/cupid_text_button.dart';
import 'package:college_cupid/routing/app_router.dart';

import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupidTextButton(
      onPressed: () async {
        final goRouter = GoRouter.of(context);
        bool cleared = await LoginStore.logout();
        if (cleared) {
          ref.read(onboardingControllerProvider.notifier).reset();
          goRouter.goNamed(AppRoutes.splash.name);
        }
      },
      text: 'Logout',
      fontColor: Colors.red[800],
    );
  }
}
