import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/functions/helpers.dart';
import 'package:college_cupid/shared/endpoints.dart';
import 'package:college_cupid/screens/profile/profile_details.dart';
import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/services/shared_prefs.dart';
import 'package:college_cupid/splash.dart';
import 'package:college_cupid/stores/common_store.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/widgets/authentication/password_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            print("******************ERROR******************");
          },
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
                String rollNumber =
                    await getElementById(controller, 'rollNumber');
                String accessToken =
                    await getElementById(controller, 'accessToken');
                String refreshToken =
                    await getElementById(controller, 'refreshToken');

                await SharedPrefs.setAccessToken(accessToken);
                await SharedPrefs.setRefreshToken(refreshToken);

                await SharedPrefs.setEmail(email);
                await SharedPrefs.setDisplayName(displayName);
                await SharedPrefs.setRollNumber(rollNumber);

                await LoginStore.initializeDisplayName();
                await LoginStore.initializeEmail();
                await LoginStore.initializeTokens();
                await LoginStore.initializeRollNumber();

                debugPrint('DATA INITIALIZED');

                Map<String, dynamic>? myProfile =
                    await APIService().getUserProfile(email);
                Map<String, dynamic>? myInfo =
                    await APIService().getPersonalInfo();

                if (myProfile == null || myInfo == null) {
                  debugPrint('NEW USER');
                  nav.pushNamedAndRemoveUntil(
                      ProfileDetails.id, (route) => false);
                } else {
                  debugPrint('USER ALREADY EXISTS');
                  debugPrint('LOGGING IN');

                  String hashedPassword = myInfo['hashedPassword'];
                  String password = await getPasswordFromUser(hashedPassword);

                  if (password.isEmpty) {
                    nav.pushNamedAndRemoveUntil(
                        SplashScreen.id, (route) => false);
                  }

                  await SharedPrefs.setPassword(password);
                  await SharedPrefs.saveMyProfile(myProfile);
                  await LoginStore.initializeMyProfile();

                  SharedPrefs.setDHPublicKey(LoginStore.myProfile['publicKey']);
                  SharedPrefs.setDHPrivateKey(BigInt.parse(
                          Encryption.decryptAES(
                              encryptedText: Encryption.hexadecimalToBytes(
                                  myInfo['encryptedPrivateKey']),
                              key: (await SharedPrefs.getPassword())!))
                      .toString());

                  nav.pushNamedAndRemoveUntil(
                      SplashScreen.id, (route) => false);
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
