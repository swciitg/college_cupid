import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/stores/common_store.dart';
import 'package:college_cupid/widgets/global/cupid_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class PasswordAlertDialog extends StatefulWidget {
  final String hashedPassword;
  const PasswordAlertDialog({required this.hashedPassword, super.key});

  @override
  State<PasswordAlertDialog> createState() => _PasswordAlertDialogState();
}

class _PasswordAlertDialogState extends State<PasswordAlertDialog> {
  final TextEditingController passwordController = TextEditingController();

  bool verifyPassword(String hashedPassword, String enteredPassword) {
    return hashedPassword ==
        Encryption.bytesToHexadecimal(
            Encryption.calculateSHA256(enteredPassword));
  }

  @override
  Widget build(BuildContext context) {
    final commonStore = context.read<CommonStore>();
    return Observer(
      builder: (_) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text("Enter Password"),
            content: TextFormField(
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: CupidColors.pinkColor, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: CupidColors.pinkColor, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  )),
              controller: passwordController,
              obscureText: true,
            ),
            actions: <Widget>[
              // const Padding(padding: EdgeInsets.only(top: 20)),
              CupidButton(
                backgroundColor: CupidColors.pinkColor,
                text: "Continue",
                onTap: () {
                  bool matched =
                  verifyPassword(widget.hashedPassword, passwordController.text);
                  if (matched) {
                    commonStore.setPassword(passwordController.text);
                    Navigator.of(context).pop();
                  } else {
                    showSnackBar('Incorrect Password');
                    passwordController.clear();
                  }
                },
              ),
            ],
          ),
        );
      }
    );
  }
}
