import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/functions/diffie_hellman.dart';
import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/presentation/widgets/global/profile_options_bottom_sheet.dart';
import 'package:college_cupid/presentation/widgets/profile/display_profile_info.dart';
import 'package:college_cupid/repositories/crushes_repository.dart';
import 'package:college_cupid/routing/app_router.dart';

import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/common_store.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final UserProfile userProfile;
  final bool isMine;

  const UserProfileScreen({required this.isMine, required this.userProfile, super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  late UserProfile profile;

  @override
  void initState() {
    profile = widget.userProfile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final crushesRepo = ref.read(crushesRepoProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.isMine
          ? null
          : AppBar(
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: CupidColors.pinkColor,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      context: context,
                      builder: (context) => ProfileOptionsBottomSheet(
                        userEmail: widget.userProfile.email,
                      ),
                    );
                  },
                ),
              ],
              systemOverlayStyle: CupidStyles.statusBarStyle,
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              centerTitle: false,
              title: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('CollegeCupid',
                    style: TextStyle(
                      fontFamily: 'SedgwickAve',
                      color: CupidColors.titleColor,
                      fontSize: 32,
                    )),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CupidColors.titleColor,
        onPressed: () async {
          if (widget.isMine) {
            context.pushNamed(AppRoutes.editProfile.name).then((value) {
              setState(() {
                profile = UserProfile.fromJson(context.read<CommonStore>().myProfile);
              });
            });
          } else {
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
          }
        },
        child: Icon(
          widget.isMine ? FluentIcons.edit_12_filled : Icons.favorite,
          size: 30,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: DisplayProfileInfo(userProfile: profile),
      ),
    );
  }
}
