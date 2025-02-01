import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/profile/icon_label_text.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  final UserProfile userProfile;

  const UserInfo({required this.userProfile, super.key});

  @override
  Widget build(BuildContext context) {
    Program program = userProfile.program!;
    String programAndYearDisplayString = "${program.displayString} '${userProfile.yearOfJoin}";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            userProfile.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
          ),
        ),
        IconLabelText(text: userProfile.email, icon: FluentIcons.mail_32_filled),
        IconLabelText(
          text: programAndYearDisplayString,
          icon: FluentIcons.hat_graduation_12_filled,
        )
      ],
    );
  }
}
