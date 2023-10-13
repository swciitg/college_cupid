import 'package:college_cupid/globals/database_strings.dart';
import 'package:college_cupid/globals/endpoints.dart';
import 'package:college_cupid/services/auth_helpers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWebview extends StatefulWidget {
  static String id = '/loginWebview';

  const LoginWebview({super.key});

  @override
  State<LoginWebview> createState() => _LoginWebviewState();
}

class _LoginWebviewState extends State<LoginWebview> {
  late WebViewController controller;

  Future<Object> injectJavascript(WebViewController controller) async {
    return controller.runJavaScriptReturningResult(
        "document.querySelector('#userTokens').innerText");
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
          onPageFinished: (String url) async {
            if (url.startsWith(
                '${Endpoints.oneStopbaseUrl}/auth/microsoft/redirect?code')) {
              var userTokenObject = await injectJavascript(controller);
              String userTokenString =
                  userTokenObject.toString().replaceAll('"', '');
              if (userTokenString != 'ERROR OCCURED!') {
                if (!mounted) return;
                Map userTokens = {
                  BackendHelper.accessToken: userTokenString.split('/')[0],
                  BackendHelper.refreshToken: userTokenString.split('/')[1]
                };
                print(userTokens);
                await AuthUserHelpers.setAccessToken(
                    userTokens[BackendHelper.accessToken]);
                await AuthUserHelpers.setRefreshToken(
                    userTokens[BackendHelper.refreshToken]);
              }
            }
          },
          onPageStarted: (String url) {}))
      ..loadRequest(Uri.parse('${Endpoints.oneStopbaseUrl}/auth/microsoft'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
