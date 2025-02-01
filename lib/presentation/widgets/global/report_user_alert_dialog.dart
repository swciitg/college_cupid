import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/presentation/widgets/global/cupid_button.dart';
import 'package:college_cupid/repositories/user_moderation_repository.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportUserAlertDialog extends ConsumerStatefulWidget {
  final String userEmail;

  const ReportUserAlertDialog({required this.userEmail, super.key});

  @override
  ConsumerState<ReportUserAlertDialog> createState() =>
      _ReportUserAlertDialogState();
}

class _ReportUserAlertDialogState extends ConsumerState<ReportUserAlertDialog> {
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
                await UserModerationRepository.reportAndBlockUser(
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
