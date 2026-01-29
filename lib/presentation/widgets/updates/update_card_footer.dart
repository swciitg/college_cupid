import 'package:college_cupid/domain/models/update_model.dart';
import 'package:college_cupid/functions/diffie_hellman.dart';
import 'package:college_cupid/presentation/widgets/profile/profile_image.dart';
import 'package:college_cupid/repositories/crushes_repository.dart';
import 'package:college_cupid/repositories/onedrive_repository.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UpdateCardFooter extends ConsumerWidget {
  final UpdateModel update;

  const UpdateCardFooter({super.key, required this.update});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: ProfileImage(
            url: update.senderUser.images.isNotEmpty
                ? update.senderUser.images.first.url
                : '',
            blurHash: update.senderUser.images.isNotEmpty
                ? update.senderUser.images.first.blurHash
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
              update.senderUser.name,
              style:
                  CupidTextStyles.label2.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            final crushesRepo = ref.read(crushesRepoProvider);
            final profile = update.senderUser;

            if (LoginStore.dhPrivateKey == null) {
              return;
            }

            final sharedSecret = DiffieHellman.generateSharedSecret(
              otherPublicKey: BigInt.parse(profile.publicKey),
              myPrivateKey: BigInt.parse(LoginStore.dhPrivateKey!),
            ).toString();

            try {
              bool success = await crushesRepo.addCrush(sharedSecret);
              if (success) {
                await OneDriveRepository.addCrush(profile.email);
                await crushesRepo.increaseCrushesCount(profile.email);
              }
            } catch (e) {
              debugPrint("Error adding crush: $e");
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  'Smash',
                  style: CupidTextStyles.label3
                      .copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 4),
                const Icon(
                  FluentIcons.heart_24_regular,
                  size: 14,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
