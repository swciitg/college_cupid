import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/presentation/widgets/global/cupid_button.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordAlertDialog extends ConsumerStatefulWidget {
  final String hashedPassword;

  const PasswordAlertDialog({required this.hashedPassword, super.key});

  @override
  ConsumerState<PasswordAlertDialog> createState() => _PasswordAlertDialogState();
}

class _PasswordAlertDialogState extends ConsumerState<PasswordAlertDialog> {
  final TextEditingController passwordController = TextEditingController();

  bool verifyPassword(String hashedPassword, String enteredPassword) {
    return hashedPassword ==
        Encryption.bytesToHexadecimal(Encryption.calculateSHA256(enteredPassword));
  }

  void _confirmSubmit() {
    final userController = ref.read(userProvider.notifier);
    bool matched = verifyPassword(widget.hashedPassword, passwordController.text);
    if (matched) {
      userController.setPassword(passwordController.text);
      Navigator.of(context).pop();
    } else {
      showSnackBar('Incorrect Password');
      passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Enter Password"),
        content: TextFormField(
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: CupidColors.pinkColor, width: 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: CupidColors.pinkColor, width: 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              )),
          controller: passwordController,
          obscureText: true,
          onFieldSubmitted: (val) {
            _confirmSubmit();
          },
        ),
        actions: [
          CupidButton(
            backgroundColor: CupidColors.pinkColor,
            text: "Continue",
            onTap: _confirmSubmit,
          ),
        ],
      ),
    );
  }
}
