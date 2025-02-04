import 'package:college_cupid/presentation/widgets/global/report_user_alert_dialog.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/page_view_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileOptionsBottomSheet extends ConsumerWidget {
  final String userEmail;

  const ProfileOptionsBottomSheet({required this.userEmail, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageViewStore = ref.read(pageViewProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () async {
                  final nav = Navigator.of(context);
                  await showDialog(
                    context: context,
                    builder: (context) =>
                        ReportUserAlertDialog(userEmail: userEmail),
                  );
                  nav.pop();
                  pageViewStore.removeHomeTabProfile(userEmail);
                },
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FluentIcons.flag_24_regular,
                      color: CupidColors.titleColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Report and Block User',
                      style: CupidStyles.textButtonStyle,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
