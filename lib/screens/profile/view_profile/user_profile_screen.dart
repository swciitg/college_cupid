import 'package:college_cupid/functions/diffie_hellman.dart';
import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/models/user_profile.dart';
import 'package:college_cupid/screens/profile/edit_profile/edit_profile.dart';
import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/widgets/profile/display_profile_info.dart';
import 'package:college_cupid/widgets/global/profile_options_bottom_sheet.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import '../../../shared/colors.dart';

class UserProfileScreen extends StatefulWidget {
  final UserProfile userProfile;
  final bool isMine;

  const UserProfileScreen(
      {required this.isMine, required this.userProfile, super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late UserProfile profile;

  @override
  void initState() {
    profile = widget.userProfile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.isMine
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBar(
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
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CupidColors.titleColor,
        onPressed: () async {
          if (widget.isMine) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfile(),
                )).then((value) {
              setState(() {
                profile = UserProfile.fromJson(LoginStore.myProfile);
              });
            });
          } else {
            String sharedSecret = DiffieHellman.generateSharedSecret(
                    otherPublicKey: BigInt.parse(profile.publicKey),
                    myPrivateKey: BigInt.parse(LoginStore.dhPrivateKey!))
                .toString();
            String encryptedCrushEmail = Encryption.bytesToHexadecimal(
                Encryption.encryptAES(
                    plainText: profile.email, key: LoginStore.password!));

            await APIService().addCrush(sharedSecret, encryptedCrushEmail);
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
