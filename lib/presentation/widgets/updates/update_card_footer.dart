import 'package:college_cupid/domain/models/update_model.dart';
import 'package:college_cupid/presentation/widgets/profile/profile_image.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UpdateCardFooter extends ConsumerWidget {
  final UpdateModel update;

  const UpdateCardFooter({super.key, required this.update});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.3))),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: ProfileImage(
                url:
                    update.senderUser!.images.isNotEmpty ? update.senderUser!.images.first.url : '',
                blurHash: update.senderUser!.images.isNotEmpty
                    ? update.senderUser!.images.first.blurHash
                    : null,
                width: 32,
                height: 32,
                index: 0,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context.pushNamed(
                    AppRoutes.userProfileScreen.name,
                    extra: {
                      'userProfile': update.senderUser,
                      'isMine': false,
                      'showPass': false,
                    },
                  );
                },
                child: Text(
                  update.senderUser!.name,
                  style: CupidTextStyles.label2.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
