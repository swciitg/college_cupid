import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

class DeactivateAccountAlert extends ConsumerStatefulWidget {
  final bool activateBack;
  const DeactivateAccountAlert({super.key, this.activateBack = false});

  @override
  ConsumerState<DeactivateAccountAlert> createState() =>
      _DeactivateAccountAlertState();
}

class _DeactivateAccountAlertState
    extends ConsumerState<DeactivateAccountAlert> {
  final reportingReasonController = TextEditingController();

  @override
  void dispose() {
    reportingReasonController.dispose();
    super.dispose();
  }

  void _deactivate() async {
    try {
      final goRouter = GoRouter.of(context);
      final user = ref.read(userProvider).myProfile!;
      final deactivate =
          await ref.read(userProfileRepoProvider).deactivateAccount(user);
      if (!deactivate) {
        goRouter.pop();
        showSnackBar("Couldn't deactivate your account");
        return;
      }
      bool cleared = await LoginStore.logout();
      await GetStorage().erase();
      if (cleared) {
        ref.read(onboardingControllerProvider.notifier).reset();
        goRouter.goNamed(AppRoutes.splash.name);
      }
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  void _activate() async {
    try {
      final goRouter = GoRouter.of(context);
      final user = ref.read(userProvider).myProfile!;
      final result =
          await ref.read(userProfileRepoProvider).activateAccount(user);
      if (!result) {
        goRouter.pop();
        showSnackBar("Couldn't activate your account");
        return;
      }
      bool cleared = await LoginStore.logout();
      await GetStorage().erase();
      if (cleared) {
        ref.read(onboardingControllerProvider.notifier).reset();
        goRouter.goNamed(AppRoutes.splash.name);
      }
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.activateBack ? "Activate" : "Deactivate"} Account',
          style: CupidStyles.subHeadingTextStyle),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      content: widget.activateBack
          ? null
          : const Text(
              "Your account will not visible to anyone.",
              style: CupidStyles.normalTextStyle,
            ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop(false);
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: Text(
                "Cancel",
                style: CupidStyles.normalTextStyle.copyWith(fontSize: 16),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: widget.activateBack ? _activate : _deactivate,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: CupidColors.secondaryColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: Text(
                "Submit",
                style: CupidStyles.normalTextStyle.copyWith(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
