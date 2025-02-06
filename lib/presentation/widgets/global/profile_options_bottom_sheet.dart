import 'package:college_cupid/presentation/widgets/global/report_user_alert_dialog.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/page_view_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileOptionsBottomSheet extends ConsumerWidget {
  final String name;
  final String userEmail;

  const ProfileOptionsBottomSheet({
    required this.name,
    required this.userEmail,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageViewStore = ref.read(pageViewProvider.notifier);
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(16).copyWith(bottom: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async {
                final nav = Navigator.of(context);
                final result = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => ReportUserAlertDialog(
                          name: name, userEmail: userEmail),
                    ) as bool? ??
                    false;
                nav.pop();
                if (!result) return;
                pageViewStore.removeHomeTabProfile(userEmail);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 16),
                  const Icon(
                    FluentIcons.flag_16_regular,
                    color: CupidColors.secondaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Report and Block User',
                      style: CupidStyles.normalTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
