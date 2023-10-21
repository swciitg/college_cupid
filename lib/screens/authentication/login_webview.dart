import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/functions/string_extension.dart';
import 'package:college_cupid/globals/database_strings.dart';
import 'package:college_cupid/globals/endpoints.dart';
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

  Future<Object> injectJavascript(
      WebViewController controller, String elementId) async {
    return controller.runJavaScriptReturningResult(
        "document.querySelector('#$elementId').innerText");
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
              var authStatusObject =
                  await injectJavascript(controller, 'status');
              String authStatusString =
                  authStatusObject.toString().replaceAll('"', '');
              if (authStatusString == 'SUCCESS') {
                if (!mounted) return;
                String email = (await injectJavascript(controller, 'email'))
                    .toString()
                    .replaceAll('"', '');
                String displayName =
                    (await injectJavascript(controller, 'displayName'))
                        .toString()
                        .replaceAll('"', '')
                        .toTitleCase();
                String accessToken =
                    (await injectJavascript(controller, 'accessToken'))
                        .toString()
                        .replaceAll('"', '');
                String refreshToken =
                    (await injectJavascript(controller, 'refreshToken'))
                        .toString()
                        .replaceAll('"', '');
                Map userTokens = {
                  BackendHelper.accessToken: accessToken,
                  BackendHelper.refreshToken: refreshToken
                };
                debugPrint(userTokens.toString());
                await SharedPrefs.setAccessToken(
                    userTokens[BackendHelper.accessToken]);
                await SharedPrefs.setRefreshToken(
                    userTokens[BackendHelper.refreshToken]);

                await SharedPrefs.setEmail(email);
                await SharedPrefs.setDisplayName(displayName);

                await LoginStore.initializeDisplayName();
                await LoginStore.initializeEmail();
                await LoginStore.initializeTokens();

                Map<String, dynamic>? data =
                    await APIService().getPersonalInfo();

                if (data == null) {
                  debugPrint('NEW USER');
                  nav.pushNamedAndRemoveUntil(
                      ProfileDetails.id, (route) => false);
                } else {
                  debugPrint('USER ALREADY EXISTS');
                  debugPrint('LOGGING IN');
                  await SharedPrefs.saveMyInfo(data);
                  await LoginStore.initializeMyInfo();

                  //TODO: ADD A POPUP FOR PASSWORD VERIFICATION
                  //TODO: INITIALIZE PASSWORD
                  SharedPrefs.setPassword('value');
                  SharedPrefs.setPublicKey(LoginStore.myInfo['publicKey']);
                  SharedPrefs.setPrivateKey(Encryption.decryptAES(
                      Encryption.hexadecimalToBytes(
                          LoginStore.myInfo['encryptedPrivateKey']),
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
