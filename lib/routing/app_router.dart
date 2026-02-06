import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/screens/authentication/login_webview.dart';
import 'package:college_cupid/presentation/screens/authentication/welcome.dart';
import 'package:college_cupid/presentation/screens/blocked_users/blocked_user_list_screen.dart';
import 'package:college_cupid/presentation/screens/home/home.dart';
import 'package:college_cupid/presentation/screens/profile/edit_profile/edit_interests.dart';
import 'package:college_cupid/presentation/screens/profile/edit_profile/edit_profile.dart';
import 'package:college_cupid/presentation/screens/profile/view_profile/user_profile_screen.dart';
import 'package:college_cupid/presentation/screens/profile_setup/profile_setup.dart';
import 'package:college_cupid/presentation/screens/restore/restore_drive_screen.dart';
import 'package:college_cupid/splash.dart';
import 'package:flutter/material.dart';
import 'package:college_cupid/presentation/screens/confessions/create_confession_screen.dart';
import 'package:go_router/go_router.dart';

enum AppRoutes {
  splash,
  home,
  welcome,
  loginWebview,
  profileSetup,
  restoreDrive,
  blockedUserListScreen,
  userProfileScreen,
  editProfile,
  editInterests,
  createConfession,
}

final navigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      name: AppRoutes.splash.name,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/${AppRoutes.welcome.name}',
      name: AppRoutes.welcome.name,
      builder: (context, state) => const Welcome(),
    ),
    GoRoute(
      path: '/${AppRoutes.loginWebview.name}',
      name: AppRoutes.loginWebview.name,
      builder: (context, state) => const LoginWebview(),
    ),
    GoRoute(
      path: '/${AppRoutes.profileSetup.name}',
      name: AppRoutes.profileSetup.name,
      builder: (context, state) => const ProfileSetup(),
    ),
    GoRoute(
      path: '/${AppRoutes.restoreDrive.name}',
      name: AppRoutes.restoreDrive.name,
      builder: (context, state) => const RestoreDriveScreen(),
    ),
    GoRoute(
      path: '/${AppRoutes.home.name}',
      name: AppRoutes.home.name,
      builder: (context, state) => const Home(),
      routes: [
        GoRoute(
          path: AppRoutes.userProfileScreen.name,
          name: AppRoutes.userProfileScreen.name,
          builder: (context, state) {
            final props = state.extra as Map<String, dynamic>;
            return UserProfileScreen(
              isMine: props['isMine'] as bool,
              userProfile: props['userProfile'] as UserProfile,
              showPass: props['showPass'] as bool? ?? true,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.editProfile.name,
          name: AppRoutes.editProfile.name,
          builder: (context, state) => const EditProfile(),
          routes: [
            GoRoute(
              path: AppRoutes.editInterests.name,
              name: AppRoutes.editInterests.name,
              builder: (context, state) => const EditInterests(),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.blockedUserListScreen.name,
          name: AppRoutes.blockedUserListScreen.name,
          builder: (context, state) => const BlockedUserListScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/${AppRoutes.createConfession.name}',
      name: AppRoutes.createConfession.name,
      builder: (context, state) => const CreateConfessionScreen(),
    ),
  ],
);
