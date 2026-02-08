import 'package:college_cupid/repositories/storage_provider.dart';
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

        // Initialize user profile first to get storage type
        if (!mounted) return;
        await ref.read(userProvider.notifier).initializeProfile();

        // Now try to restore Google Drive session if user was using it
        try {
          final userProfile = ref.read(userProvider).myProfile;
          final storageType = userProfile?.storageType;

          if (storageType?.name == 'googleDrive') {
            debugPrint('User storage type: Google Drive - Attempting to restore session...');
            final storageRepo = ref.read(storageRepositoryProvider);
            final initialized = await storageRepo.initializeWithStoredTokens();
            if (initialized) {
              debugPrint('Google Drive session restored successfully');
            } else {
              debugPrint('Failed to restore Google Drive session - user may need to reconnect');
            }
          } else if (storageType?.name == 'localStorage') {
            debugPrint('User storage type: Local Storage - Skipping Google Drive initialization');
          } else {
            debugPrint('User storage type: Unknown or not set (${storageType?.name})');
          }
        } catch (e) {
          debugPrint('Failed to restore Google Drive session: $e');
          // Continue anyway - user can reconnect later if needed
        }

        if (!mounted) return;
        final goRouter = GoRouter.of(context);
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
    return Scaffold(
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(90),
          child: Image.asset(
            'assets/images/app_logo.jpg',
            fit: BoxFit.cover,
            height: 180,
            width: 180,
          ),
        ),
      ),
    );
  }
}
