import 'dart:convert';
import 'dart:developer';
import 'package:college_cupid/domain/models/drive_data.dart';
import 'package:college_cupid/domain/models/storage_type.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/functions/diffie_hellman.dart';
import 'package:college_cupid/functions/helpers.dart';
import 'package:college_cupid/repositories/personal_info_repository.dart';
import 'package:college_cupid/repositories/storage_provider.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/services/secure_storage_service.dart';
import 'package:college_cupid/services/shared_prefs.dart';
import 'package:college_cupid/shared/colors.dart';
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

  Future<String> getElementById(WebViewController controller, String elementId) async {
    var element = await controller
        .runJavaScriptReturningResult("document.querySelector('#$elementId').innerText");
    String newString = element.toString();
    if (element.toString().startsWith('"')) {
      newString = element.toString().substring(1, element.toString().length - 1);
    }
    return newString.replaceAll('\\', '');
  }

  // Future<void> getPasswordFromUser(String hashedPassword) async {
  //   await showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return PasswordAlertDialog(hashedPassword: hashedPassword);
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    debugPrint('BASE URL: ${Endpoints.baseUrl}');
    final userProfileRepo = ref.read(userProfileRepoProvider);
    final personalInfoRepo = ref.read(personalInfoRepoProvider);
    // final userController = ref.read(userProvider.notifier);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            final goRouter = GoRouter.of(context);

            if (!url.startsWith('${Endpoints.baseUrl}/auth/microsoft/redirect?code')) {
              return;
            }

            String authStatus = await getElementById(controller, 'status');
            if (authStatus != 'SUCCESS') return;
            if (!mounted) return;
            String outlookInfoString =
                (await getElementById(controller, 'outlookInfo')).replaceAll("\\", '"');
            // print(outlookInfoString);

            Map<String, dynamic> outlookInfo = jsonDecode(outlookInfoString);

            final displayName = outlookInfo['displayName']!.toString().toTitleCase();
            final rollNumber = outlookInfo['rollNumber']!;
            final accessToken = outlookInfo['accessToken']!;
            final refreshToken = outlookInfo['refreshToken']!;
            final email = outlookInfo['email']!;
            final outlookAccessToken = outlookInfo['outlookAccessToken'];
            final outlookRefreshToken = outlookInfo['outlookRefreshToken'];

            await SecureStorageService.setOutlookAccessToken(outlookAccessToken);
            await SecureStorageService.setOutlookRefreshToken(outlookRefreshToken);

            await SharedPrefService.setOutlookInfo(
              accessToken: accessToken,
              refreshToken: refreshToken,
              email: email,
              displayName: displayName,
              rollNumber: rollNumber,
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
              debugPrint('USER ALREADY EXISTS - RETURNING USER');

              // Parse the user profile to check storage type
              final userProfileData = UserProfile.fromJson(myProfile);
              final storageType = userProfileData.storageType;

              debugPrint('User storage type: ${storageType.name}');

              // Only show restore page if user was using Google Drive
              if (storageType == StorageType.googleDrive) {
                debugPrint('NAVIGATING TO RESTORE PAGE');
                goRouter.goNamed(
                  AppRoutes.restoreDrive.name,
                  queryParameters: {
                    'googleEmail': userProfileData.googleAccountEmail ?? '',
                  },
                );
              } else {
                debugPrint('LOCAL STORAGE USER - LOADING DATA AND SKIPPING RESTORE PAGE');

                // Set storage type in provider
                ref.read(storageTypeProvider.notifier).state = storageType;

                // Load user profile and personal info into providers
                await ref.read(userProvider.notifier).updateMyProfile(userProfileData);
                await SharedPrefService.setDHPublicKey(userProfileData.publicKey);

                // Load DH private key from local storage
                var dhPrivateKey = await SharedPrefService.getDHPrivateKey();

                // If no private key exists, generate new keys and store them
                if (dhPrivateKey == null || dhPrivateKey.isEmpty) {
                  debugPrint('No keys found - generating new keys for local storage user');

                  final keyPair = DiffieHellman.generateKeyPair();
                  dhPrivateKey = keyPair.privateKey.toString();
                  final publicKey = keyPair.publicKey.toString();

                  // Store keys locally
                  await SharedPrefService.setDHPrivateKey(dhPrivateKey);
                  await SharedPrefService.setDHPublicKey(publicKey);

                  // Update public key in user profile
                  final updatedProfile = userProfileData.copyWith(publicKey: publicKey);
                  await ref.read(userProfileRepoProvider).updateUserProfile(updatedProfile);
                  await ref.read(userProvider.notifier).updateMyProfile(updatedProfile);

                  // Save keys to local storage
                  final storageRepo = ref.read(storageRepositoryProvider);
                  final driveData = DriveData(
                    diffieHellmanPrivateKey: dhPrivateKey,
                    crushEmailList: [],
                  );
                  await storageRepo.uploadPrivateData(driveData);

                  debugPrint('Keys generated and stored successfully');
                }

                LoginStore.dhPrivateKey = dhPrivateKey;

                debugPrint('User data loaded - navigating to home');
                // Local storage users can go directly to home
                goRouter.goNamed(AppRoutes.home.name);
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
      backgroundColor: CupidColors.backgroundColor,
      body: SafeArea(
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}
