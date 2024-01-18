import 'package:college_cupid/splash.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/widgets/global/cupid_text_button.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CupidTextButton(
      onPressed: () async {
        NavigatorState nav = Navigator.of(context);
        bool cleared = await LoginStore.logout();
        if (cleared) {
          nav.pushNamedAndRemoveUntil(SplashScreen.id, (route) => false);
        }
      },
      text: 'Logout',
      fontColor: Colors.red[800],
    );
  }
}
