import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/functions/string_extension.dart';
import 'package:college_cupid/shared/endpoints.dart';
import 'package:college_cupid/screens/profile/profile_details.dart';
import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/services/shared_prefs.dart';
import 'package:college_cupid/splash.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWebview extends StatefulWidget {
  static String id = '/loginWebview';

  const LoginWebview({super.key});

  @override
  State<LoginWebview> createState() => _LoginWebviewState();
}

class _LoginWebviewState extends State<LoginWebview> {
  late WebViewController controller;

  Future<String> getElementById(
      WebViewController controller, String elementId) async {
    var element = await controller.runJavaScriptReturningResult(
        "document.querySelector('#$elementId').innerText");

    return element.toString().replaceAll('"', '');
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
          onPageFinished: (String url) async {
            NavigatorState nav = Navigator.of(context);

            if (url.startsWith(
                '${Endpoints.baseUrl}/auth/microsoft/redirect?code')) {
              String authStatus = await getElementById(controller, 'status');
              if (authStatus == 'SUCCESS') {
                if (!mounted) return;
                String email = await getElementById(controller, 'email');
                String displayName =
                    (await getElementById(controller, 'displayName'))
                        .toTitleCase();
                String accessToken =
                    await getElementById(controller, 'accessToken');
                String refreshToken =
                    await getElementById(controller, 'refreshToken');

                await SharedPrefs.setAccessToken(accessToken);
                await SharedPrefs.setRefreshToken(refreshToken);

                await SharedPrefs.setEmail(email);
                await SharedPrefs.setDisplayName(displayName);

                await LoginStore.initializeDisplayName();
                await LoginStore.initializeEmail();
                await LoginStore.initializeTokens();

                debugPrint('DATA INITIALIZED');

                Map<String, dynamic>? myProfile =
                    await APIService().getUserProfile(email);
                Map<String, dynamic>? myInfo =
                    await APIService().getPersonalInfo();

                if (myProfile == null) {
                  debugPrint('NEW USER');
                  nav.pushNamedAndRemoveUntil(
                      ProfileDetails.id, (route) => false);
                } else {
                  debugPrint('USER ALREADY EXISTS');
                  debugPrint('LOGGING IN');
                  await SharedPrefs.saveMyProfile(myProfile);
                  await LoginStore.initializeMyProfile();

                  String hashedPassword = myInfo!['hashedPassword'];
                  print(hashedPassword);

                  //TODO: ADD A POPUP FOR PASSWORD VERIFICATION
                  //TODO: INITIALIZE PASSWORD
                  SharedPrefs.setPassword('value');
                  SharedPrefs.setDHPublicKey(LoginStore.myProfile['publicKey']);
                  SharedPrefs.setDHPrivateKey(Encryption.decryptAES(
                      Encryption.hexadecimalToBytes(
                          myInfo['encryptedPrivateKey']),
                      await SharedPrefs.getPassword()));

                  nav.pushNamedAndRemoveUntil(
                      SplashScreen.id, (route) => false);
                }
              }
            }
          },
          onPageStarted: (String url) {}))
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
