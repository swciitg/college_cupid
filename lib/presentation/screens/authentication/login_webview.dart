import 'dart:convert';
import 'dart:developer';

import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/functions/helpers.dart';
import 'package:college_cupid/presentation/widgets/authentication/password_alert_dialog.dart';
import 'package:college_cupid/repositories/onedrive_repository.dart';
import 'package:college_cupid/repositories/personal_info_repository.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/services/shared_prefs.dart';
import 'package:college_cupid/shared/endpoints.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWebview extends ConsumerStatefulWidget {
  const LoginWebview({super.key});

  @override
  ConsumerState<LoginWebview> createState() => _LoginWebviewState();
}

class _LoginWebviewState extends ConsumerState<LoginWebview> {
  late WebViewController controller;

  Future<String> getElementById(
      WebViewController controller, String elementId) async {
    var element = await controller.runJavaScriptReturningResult(
        "document.querySelector('#$elementId').innerText");
    String newString = element.toString();
    if (element.toString().startsWith('"')) {
      newString =
          element.toString().substring(1, element.toString().length - 1);
    }
    return newString.replaceAll('\\', '');
  }

  Future<void> getPasswordFromUser(String hashedPassword) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PasswordAlertDialog(hashedPassword: hashedPassword);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    final userProfileRepo = ref.read(userProfileRepoProvider);
    final personalInfoRepo = ref.read(personalInfoRepoProvider);
    final userController = ref.read(userProvider.notifier);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            final goRouter = GoRouter.of(context);

            if (url.startsWith(
                '${Endpoints.baseUrl}/auth/microsoft/redirect?code')) {
              String authStatus = await getElementById(controller, 'status');
              if (authStatus == 'SUCCESS') {
                if (!mounted) return;
                String outlookInfoString =
                    (await getElementById(controller, 'outlookInfo'))
                        .replaceAll("\\", '"');

                Map<String, dynamic> outlookInfo =
                    jsonDecode(outlookInfoString);

                final displayName =
                    outlookInfo['displayName']!.toString().toTitleCase();
                final rollNumber = outlookInfo['rollNumber']!;
                final accessToken = outlookInfo['accessToken']!;
                final refreshToken = outlookInfo['refreshToken']!;
                final email = outlookInfo['email']!;
                final outlookAccessToken = outlookInfo['outlookAccessToken'];

                await SharedPrefService.setOutlookInfo(
                  accessToken: accessToken,
                  refreshToken: refreshToken,
                  email: email,
                  displayName: displayName,
                  rollNumber: rollNumber,
                  outlookAccessToken: outlookAccessToken,
                );

                await LoginStore.initializeOutlookInfo();

                debugPrint('DATA INITIALIZED');

                final myProfile = await userProfileRepo.getUserProfile(email);
                final myInfo = await personalInfoRepo.getPersonalInfo();

                await WebViewCookieManager().clearCookies();

                if (myProfile == null || myInfo == null) {
                  log('NEW USER');
                  goRouter.goNamed(AppRoutes.profileSetup.name);
                } else {
                  debugPrint('USER ALREADY EXISTS');
                  debugPrint('LOGGING IN');

                  final dhPvtKey = await OneDriveRepository.getDHPrivateKey();
                  if (dhPvtKey == null) {
                    // SOMEONE CLEARED ONEDRIVE DATA
                    // TODO: DO SOMETHING HERE
                    LoginStore.logout();
                    goRouter.goNamed(AppRoutes.splash.name);
                  } else {
                    final userProfileMap =
                        await userProfileRepo.getUserProfile(email);
                    final userProfile = UserProfile.fromJson(userProfileMap!);
                    await userController.updateMyProfile(userProfile);
                    await SharedPrefService.setDHPublicKey(
                        userProfile.publicKey);
                    await SharedPrefService.setDHPrivateKey(dhPvtKey);

                    goRouter.goNamed(AppRoutes.splash.name);
                  }
                }
              }
            }
          },
        ),
      )
      ..loadRequest(Uri.parse('${Endpoints.baseUrl}/auth/microsoft'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}
