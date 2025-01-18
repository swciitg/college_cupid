import 'dart:convert';
import 'dart:developer';

import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/functions/helpers.dart';
import 'package:college_cupid/presentation/widgets/authentication/password_alert_dialog.dart';
import 'package:college_cupid/repositories/personal_info_repository.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/routing/app_router.dart';

import 'package:college_cupid/services/shared_prefs.dart';
import 'package:college_cupid/shared/endpoints.dart';
import 'package:college_cupid/stores/common_store.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWebview extends ConsumerStatefulWidget {
  const LoginWebview({super.key});

  @override
  ConsumerState<LoginWebview> createState() => _LoginWebviewState();
}

class _LoginWebviewState extends ConsumerState<LoginWebview> {
  late WebViewController controller;
  late CommonStore commonStore;

  Future<String> getElementById(WebViewController controller, String elementId) async {
    var element = await controller
        .runJavaScriptReturningResult("document.querySelector('#$elementId').innerText");
    String newString = element.toString();
    if (element.toString().startsWith('"')) {
      newString = element.toString().substring(1, element.toString().length - 1);
    }
    return newString.replaceAll('\\', '');
  }

  Future<String> getPasswordFromUser(String hashedPassword) async {
    final commonStore = context.read<CommonStore>();
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PasswordAlertDialog(hashedPassword: hashedPassword);
      },
    );
    return commonStore.password;
  }

  @override
  void initState() {
    super.initState();
    final userProfileRepo = ref.read(userProfileRepoProvider);
    final personalInfoRepo = ref.read(personalInfoRepoProvider);

    commonStore = context.read<CommonStore>();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            final goRouter = GoRouter.of(context);

            if (url.startsWith('${Endpoints.baseUrl}/auth/microsoft/redirect?code')) {
              String authStatus = await getElementById(controller, 'status');
              if (authStatus == 'SUCCESS') {
                if (!mounted) return;
                String outlookInfoString =
                    (await getElementById(controller, 'outlookInfo')).replaceAll("\\", '"');

                Map<String, dynamic> outlookInfo = jsonDecode(outlookInfoString);

                String displayName = outlookInfo['displayName']!.toString().toTitleCase();
                String rollNumber = outlookInfo['rollNumber']!;
                String accessToken = outlookInfo['accessToken']!;
                String refreshToken = outlookInfo['refreshToken']!;
                String email = outlookInfo['email']!;

                await SharedPrefs.setOutlookInfo(
                    accessToken: accessToken,
                    refreshToken: refreshToken,
                    email: email,
                    displayName: displayName,
                    rollNumber: rollNumber);

                await LoginStore.initializeOutlookInfo();

                debugPrint('DATA INITIALIZED');

                Map<String, dynamic>? myProfile = await userProfileRepo.getUserProfile(email);
                Map<String, dynamic>? myInfo = await personalInfoRepo.getPersonalInfo();

                await WebViewCookieManager().clearCookies();

                if (myProfile == null || myInfo == null) {
                  log('NEW USER');
                  goRouter.goNamed(AppRoutes.profileDetails.name);
                } else {
                  debugPrint('USER ALREADY EXISTS');
                  debugPrint('LOGGING IN');

                  String hashedPassword = myInfo['hashedPassword'];
                  String password = await getPasswordFromUser(hashedPassword);

                  if (hashedPassword !=
                      Encryption.bytesToHexadecimal(Encryption.calculateSHA256(password))) {
                    goRouter.goNamed(AppRoutes.splash.name);
                  }

                  await SharedPrefs.setPassword(password);
                  await SharedPrefs.saveMyProfile(myProfile);
                  await commonStore.initializeProfile();
                  LoginStore.password = password;

                  SharedPrefs.setDHPublicKey(commonStore.myProfile['publicKey']);
                  SharedPrefs.setDHPrivateKey(BigInt.parse(
                    Encryption.decryptAES(
                        encryptedText: Encryption.hexadecimalToBytes(myInfo['encryptedPrivateKey']),
                        key: LoginStore.password!),
                  ).toString());

                  goRouter.goNamed(AppRoutes.splash.name);
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
