import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/screens/authentication/login_webview.dart';
import 'package:college_cupid/presentation/screens/authentication/welcome.dart';
import 'package:college_cupid/presentation/screens/blocked_users/blocked_user_list_screen.dart';
import 'package:college_cupid/presentation/screens/home/home.dart';
import 'package:college_cupid/presentation/screens/profile/edit_profile/edit_profile.dart';
import 'package:college_cupid/presentation/screens/profile/edit_profile/profile_details.dart';
import 'package:college_cupid/presentation/screens/profile/edit_profile/select_interests_screen.dart';
import 'package:college_cupid/presentation/screens/profile/view_profile/user_profile_screen.dart';
import 'package:college_cupid/routing/app_routes.dart';
import 'package:college_cupid/splash.dart';
import 'package:go_router/go_router.dart';

final goRouter =
    GoRouter(initialLocation: '/', debugLogDiagnostics: true, routes: [
  GoRoute(
    path: '/',
    name: AppRoutes.splash.name,
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: '/${AppRoutes.profileDetails.name}',
    name: AppRoutes.profileDetails.name,
    builder: (context, state) => const ProfileDetails(),
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
                userProfile: props['userProfile'] as UserProfile);
          },
        ),
        GoRoute(
            path: AppRoutes.editProfile.name,
            name: AppRoutes.editProfile.name,
            builder: (context, state) => const EditProfile(),
            routes: [
              GoRoute(
                path: AppRoutes.selectInterestsScreen.name,
                name: AppRoutes.selectInterestsScreen.name,
                builder: (context, state) => const SelectInterestsScreen(),
              ),
            ]),
        GoRoute(
          path: AppRoutes.blockedUserListScreen.name,
          name: AppRoutes.blockedUserListScreen.name,
          builder: (context, state) => const BlockedUserListScreen(),
        ),
      ]),
]);
