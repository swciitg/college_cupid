import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/functions/diffie_hellman.dart';
import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/presentation/widgets/profile/basic_profile_info.dart';
import 'package:college_cupid/presentation/widgets/profile/profile_image.dart';
import 'package:college_cupid/repositories/crushes_repository.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayProfileInfo extends ConsumerStatefulWidget {
  final UserProfile userProfile;

  const DisplayProfileInfo({required this.userProfile, super.key});

  @override
  ConsumerState<DisplayProfileInfo> createState() => _DisplayProfileInfoState();
}

class _DisplayProfileInfoState extends ConsumerState<DisplayProfileInfo> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width - 32;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: LayoutBuilder(builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BasicProfileInfo(
                    maxHeight: maxHeight,
                    width: width,
                    userProfile: widget.userProfile),
                const SizedBox(height: 8),

                // TODO: Question 1

                _image(null, width, 1),
                const SizedBox(height: 8),
                if (widget.userProfile.interests.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Loves",
                        style: CupidStyles.normalTextStyle.setFontSize(16),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _expanded = !_expanded;
                          });
                        },
                        icon: Icon(
                          _expanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                        ),
                      )
                    ],
                  ),
                if (widget.userProfile.interests.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: List.generate(
                        _expanded ? widget.userProfile.interests.length : 4,
                        (index) {
                      final extra = widget.userProfile.interests.length - 3;
                      if (!_expanded && index == 3) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _expanded = true;
                            });
                          },
                          child: Text(
                            "+$extra more",
                            style: CupidStyles.normalTextStyle,
                          ),
                        );
                      }
                      return _interestChip(
                          widget.userProfile.interests[index], index);
                    }),
                  ),
                const SizedBox(height: 16),
                if (widget.userProfile.images.length > 2)
                  _image(null, width, 2),
                // TODO: Question 2
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      }),
    );
  }

  DecoratedBox _interestChip(String label, int index) {
    final colors = {
      0: CupidColors.pinkColor.withValues(alpha: 0.1),
      1: CupidColors.cupidBlue.withValues(alpha: 0.4),
      2: CupidColors.cupidYellow.withValues(alpha: 0.4),
    };
    final color = _expanded ? null : colors[index];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: color == null ? Border.all(color: Colors.black54) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        child: Text(
          label,
          style: CupidStyles.normalTextStyle,
        ),
      ),
    );
  }

  Widget _image(double? height, double width, int index) {
    final url = widget.userProfile.images[index].url;
    final blurHash = widget.userProfile.images[index].blurHash;
    return ProfileImage(
        height: height,
        width: width,
        index: index,
        url: url,
        blurHash: blurHash);
  }

  FloatingActionButton _actionButton(
      BuildContext context, UserProfile profile) {
    final crushesRepo = ref.read(crushesRepoProvider);
    return FloatingActionButton(
      backgroundColor: CupidColors.titleColor,
      onPressed: () async {
        String sharedSecret = DiffieHellman.generateSharedSecret(
                otherPublicKey: BigInt.parse(profile.publicKey),
                myPrivateKey: BigInt.parse(LoginStore.dhPrivateKey!))
            .toString();
        String encryptedCrushEmail = Encryption.bytesToHexadecimal(
            Encryption.encryptAES(
                plainText: profile.email, key: LoginStore.password!));

        bool success =
            await crushesRepo.addCrush(sharedSecret, encryptedCrushEmail);
        if (success) {
          await crushesRepo.increaseCrushesCount(profile.email);
        }
      },
      child: const Icon(
        Icons.favorite,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}
