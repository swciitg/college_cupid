import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/presentation/widgets/global/cupid_button.dart';
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
  const DeactivateAccountAlert({super.key});

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Deactivate Account',
          style: CupidStyles.subHeadingTextStyle),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      content: TextFormField(
        decoration: const InputDecoration(
          hintText: "Reason",
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: CupidColors.secondaryColor, width: 1),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: CupidColors.secondaryColor, width: 1),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        ),
        controller: reportingReasonController,
      ),
      actions: [
        CupidButton(
            text: 'Submit',
            onTap: () async {
              try {
                final goRouter = GoRouter.of(context);
                final user = ref.read(userProvider).myProfile!;
                final deactivated = await ref
                    .read(userProfileRepoProvider)
                    .deactivateAccount(user);
                if (!deactivated) {
                  goRouter.pop();
                  showSnackBar("Couldn't deactivate your account");
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
            })
      ],
    );
  }
}
