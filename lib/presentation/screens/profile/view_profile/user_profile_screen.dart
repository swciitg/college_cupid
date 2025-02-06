import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/home/drawer_widget.dart';
import 'package:college_cupid/presentation/widgets/profile/display_profile_info.dart';
import 'package:college_cupid/repositories/crushes_repository.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final UserProfile userProfile;
  final bool isMine;

  const UserProfileScreen(
      {required this.isMine, required this.userProfile, super.key});

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
    final currentUser = ref.read(userProvider).myProfile!;
    return Scaffold(
      endDrawer: currentUser.email == widget.userProfile.email
          ? const DrawerWidget()
          : null,
      backgroundColor: Colors.white,
      appBar: _appBar(currentUser.email == widget.userProfile.email),
      floatingActionButton:
          widget.isMine ? _actionButton(context, crushesRepo) : null,
      body: SafeArea(
        child: DisplayProfileInfo(
          userProfile: profile,
          backButton: profile.email != currentUser.email,
        ),
      ),
    );
  }

  PreferredSize _appBar(bool ownProfile) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        scrolledUnderElevation: 0,
        // foregroundColor: CupidColors.pinkColor,
        systemOverlayStyle: CupidStyles.statusBarStyle,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: ownProfile
            ? const Text(
                "Your Profile",
                style: CupidStyles.headingStyle,
              )
            : const Text(""),
      ),
    );
  }

  FloatingActionButton _actionButton(
      BuildContext context, CrushesRepository crushesRepo) {
    return FloatingActionButton(
      backgroundColor: const Color(0xFFFBA8AA),
      onPressed: () async {
        context.pushNamed(AppRoutes.editProfile.name).then((value) {
          setState(() {
            profile = ref.read(userProvider).myProfile!;
          });
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: const Icon(
        FluentIcons.edit_12_filled,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}
