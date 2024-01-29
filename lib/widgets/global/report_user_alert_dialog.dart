import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/widgets/global/cupid_button.dart';
import 'package:flutter/material.dart';

class ReportUserAlertDialog extends StatefulWidget {
  final String userEmail;

  const ReportUserAlertDialog({required this.userEmail, super.key});

  @override
  State<ReportUserAlertDialog> createState() => _ReportUserAlertDialogState();
}

class _ReportUserAlertDialogState extends State<ReportUserAlertDialog> {
  final reportingReasonController = TextEditingController();

  @override
  void dispose() {
    reportingReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Reason for reporting ${widget.userEmail}',
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
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
        controller: reportingReasonController,
      ),
      actions: [
        CupidButton(
            text: 'Submit',
            onTap: () async {
              try {
                final nav = Navigator.of(context);
                if (reportingReasonController.text.isEmpty) {
                  showSnackBar("Field cannot be empty!");
                  return;
                }
                await APIService().reportAndBlockUser(
                    widget.userEmail, reportingReasonController.text);
                nav.pop();
                showSnackBar('Reported and Blocked ${widget.userEmail}');
              } catch (e) {
                showSnackBar(e.toString());
              }
            })
      ],
    );
  }
}
