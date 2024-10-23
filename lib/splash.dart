import 'package:college_cupid/presentation/widgets/global/app_title.dart';
import 'package:college_cupid/routing/app_routes.dart';
import 'package:college_cupid/stores/common_store.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    LoginStore.isAuthenticated().then((value) async {
      if (value == true &&
          LoginStore.isProfileCompleted &&
          LoginStore.isPasswordSaved) {
        debugPrint('USER IS AUTHENTICATED');
        final goRouter = GoRouter.of(context);
        await context.read<CommonStore>().initializeProfile();
        goRouter.goNamed(AppRoutes.home.name);

      } else {
        debugPrint('USER IS NOT AUTHENTICATED');
        context.goNamed(AppRoutes.welcome.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AppTitle(
          fontSize: 40,
        ),
      ),
    );
  }
}
