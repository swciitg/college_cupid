import 'package:college_cupid/presentation/widgets/global/app_title.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    LoginStore.isAuthenticated().then((value) async {
      if (value == true && LoginStore.isProfileCompleted) {
        debugPrint('USER IS AUTHENTICATED');
        if (!mounted) return;
        final goRouter = GoRouter.of(context);
        await ref.read(userProvider.notifier).initializeProfile();
        goRouter.goNamed(AppRoutes.home.name);
      } else {
        debugPrint('USER IS NOT AUTHENTICATED');
        if (!mounted) return;
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
