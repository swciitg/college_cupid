import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/profile/display_profile_info.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final myProfile = ref.watch(userProvider).myProfile;
    final profileToShow =
        widget.isMine ? myProfile ?? widget.userProfile : widget.userProfile;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: DisplayProfileInfo(
          userProfile: profileToShow,
          isMine: widget.isMine,
          backButton: !widget
              .isMine,
        ),
      ),
    );
  }
}
