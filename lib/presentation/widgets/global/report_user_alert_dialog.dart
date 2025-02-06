import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/repositories/user_moderation_repository.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportUserAlertDialog extends ConsumerStatefulWidget {
  final String name;
  final String userEmail;

  const ReportUserAlertDialog(
      {required this.name, required this.userEmail, super.key});

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
        'Reason for reporting ${widget.name}',
        style: CupidStyles.subHeadingTextStyle.copyWith(
          fontSize: 22,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      content: TextFormField(
        decoration: const InputDecoration(
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
          onTap: () async {
            try {
              final nav = Navigator.of(context);
              if (reportingReasonController.text.isEmpty) {
                showSnackBar("Field cannot be empty!");
                return;
              }
              await UserModerationRepository.reportAndBlockUser(
                  widget.userEmail, reportingReasonController.text);
              nav.pop(true);
              showSnackBar('Reported and Blocked ${widget.userEmail}');
            } catch (e) {
              showSnackBar(e.toString());
            }
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: CupidColors.secondaryColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: Text(
                "Submit",
                style: CupidStyles.normalTextStyle.copyWith(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
