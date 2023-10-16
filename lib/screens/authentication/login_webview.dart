import 'package:college_cupid/globals/endpoints.dart';
import 'package:college_cupid/screens/profile/profile_details.dart';
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
            nav.pushNamedAndRemoveUntil(ProfileDetails.id, (route) => false);
            //TODO: use college_cupid api for authentication
            // if (url.startsWith(
            //     '${Endpoints.baseUrl}/auth/microsoft/redirect?code')) {
            //   var authStatusObject =
            //       await injectJavascript(controller, 'status');
            //   String authStatusString =
            //       authStatusObject.toString().replaceAll('"', '');
            //   if (authStatusString != 'ERROR') {
            //     if (!mounted) return;
            //     String accessToken =
            //         (await injectJavascript(controller, 'accessToken'))
            //             .toString()
            //             .replaceAll('"', '');
            //     String refreshToken =
            //         (await injectJavascript(controller, 'refreshToken'))
            //             .toString()
            //             .replaceAll('"', '');
            //     Map userTokens = {
            //       BackendHelper.accessToken: accessToken,
            //       BackendHelper.refreshToken: refreshToken
            //     };
            //     print(userTokens);
            //     await AuthUserHelpers.setAccessToken(
            //         userTokens[BackendHelper.accessToken]);
            //     await AuthUserHelpers.setRefreshToken(
            //         userTokens[BackendHelper.refreshToken]);
            //     nav.pushNamedAndRemoveUntil(
            //         ProfileDetails.id, (route) => false);
            //   }
            // }
          },
          onPageStarted: (String url) {}))
      ..loadRequest(Uri.parse('${Endpoints.oneStopBaseUrl}/auth/microsoft'));
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
