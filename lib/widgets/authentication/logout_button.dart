import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/splash.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          NavigatorState nav = Navigator.of(context);
          bool cleared = await LoginStore.logout();
          if (cleared) {
            nav.pushNamedAndRemoveUntil(SplashScreen.id, (route) => false);
          }
        },
        icon: const Icon(
          Icons.logout_rounded,
          color: CupidColors.titleColor,
        ));
  }
}
