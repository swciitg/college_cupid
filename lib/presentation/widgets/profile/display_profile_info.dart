import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/functions/diffie_hellman.dart';
import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/presentation/widgets/global/profile_options_bottom_sheet.dart';
import 'package:college_cupid/presentation/widgets/profile/basic_profile_info.dart';
import 'package:college_cupid/presentation/widgets/profile/profile_image.dart';
import 'package:college_cupid/repositories/crushes_repository.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayProfileInfo extends ConsumerStatefulWidget {
  final UserProfile userProfile;
  final bool backButton;

  const DisplayProfileInfo({required this.userProfile, this.backButton = false, super.key});

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
                  userProfile: widget.userProfile,
                  backButton: widget.backButton,
                ),
                if (widget.userProfile.surpriseQuiz.isNotEmpty)
                  _surpriseQues(widget.userProfile.surpriseQuiz.first),
                if (widget.userProfile.surpriseQuiz.isEmpty) const SizedBox(height: 16),
                _image(null, width, 1),
                const SizedBox(height: 8),
                if (widget.userProfile.interests.isNotEmpty) _buildInterests(),
                const SizedBox(height: 16),
                if (widget.userProfile.images.length > 2) _image(null, width, 2),
                if (widget.userProfile.surpriseQuiz.isNotEmpty)
                  _surpriseQues(widget.userProfile.surpriseQuiz[1]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _menuButton(context),
                    _likeButton(context),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _surpriseQues(QuizQuestion ques) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ques.question,
                      style: CupidStyles.normalTextStyle.setFontWeight(FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text(ques.answer, style: CupidStyles.normalTextStyle.setFontSize(16)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInterests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                _expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              ),
            )
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(_expanded ? widget.userProfile.interests.length : 4, (index) {
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
            return _interestChip(widget.userProfile.interests[index], index);
          }),
        ),
      ],
    );
  }

  Widget _menuButton(BuildContext context) {
    final profile = widget.userProfile;
    final currentUser = ref.read(userProvider).myProfile!;
    if (profile.email == currentUser.email) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: FloatingActionButton(
        backgroundColor: CupidColors.cupidBlue,
        onPressed: () async {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            elevation: 0,
            context: context,
            builder: (context) => ProfileOptionsBottomSheet(
              userEmail: widget.userProfile.email,
            ),
          );
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: const Icon(
          FluentIcons.filter_16_regular,
          size: 24,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _likeButton(BuildContext context) {
    final crushesRepo = ref.read(crushesRepoProvider);
    final profile = widget.userProfile;
    if (profile.email == LoginStore.email) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: FloatingActionButton(
        backgroundColor: const Color(0xFFFBA8AA),
        onPressed: () async {
          String sharedSecret = DiffieHellman.generateSharedSecret(
                  otherPublicKey: BigInt.parse(profile.publicKey),
                  myPrivateKey: BigInt.parse(LoginStore.dhPrivateKey!))
              .toString();
          String encryptedCrushEmail = Encryption.bytesToHexadecimal(
              Encryption.encryptAES(plainText: profile.email, key: LoginStore.password!));

          bool success = await crushesRepo.addCrush(sharedSecret, encryptedCrushEmail);
          if (success) {
            await crushesRepo.increaseCrushesCount(profile.email);
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: const Icon(
          Icons.favorite,
          size: 24,
          color: Colors.white,
        ),
      ),
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
      blurHash: blurHash,
    );
  }
}
