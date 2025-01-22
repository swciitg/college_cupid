import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/stores/blocked_users_store.dart';
import 'package:college_cupid/stores/common_store.dart';
import 'package:college_cupid/stores/filter_store.dart';
import 'package:college_cupid/stores/interest_store.dart';
import 'package:college_cupid/stores/page_view_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:provider/provider.dart';

void main() {
  runApp(
    const riverpod.ProviderScope(
      child: CollegeCupidApp(),
    ),
  );
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final navigatorKey = GlobalKey<NavigatorState>();

class CollegeCupidApp extends StatelessWidget {
  const CollegeCupidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BlockedUsersStore>(create: (_) => BlockedUsersStore()),
        Provider<FilterStore>(create: (_) => FilterStore()),
        Provider<InterestStore>(create: (_) => InterestStore()),
        Provider<CommonStore>(create: (_) => CommonStore()),
        Provider<PageViewStore>(create: (_) => PageViewStore()),
      ],
      child: MaterialApp.router(
        title: 'CollegeCupid',
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: CupidColors.titleColor,
            cursorColor: CupidColors.secondaryColor,
            selectionColor: CupidColors.secondaryColor.withValues(alpha: 0.75),
          ),
        ),
        routerConfig: goRouter,
      ),
    );
  }
}
