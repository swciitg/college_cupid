import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/functions/diffie_hellman.dart';
import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/presentation/widgets/profile/display_profile_info.dart';
import 'package:college_cupid/repositories/crushes_repository.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/filter_store.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/stores/page_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

class ProfileView extends ConsumerStatefulWidget {
  final List<UserProfile> userProfiles;

  const ProfileView({required this.userProfiles, super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  late FilterStore filterStore;
  late PageViewState pageViewState;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    filterStore.resetStore();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfileRepo = ref.read(userProfileRepoProvider);
    filterStore = context.read<FilterStore>();
    pageViewState = ref.watch(pageViewProvider);
    _pageController = PageController(
        initialPage: ref.read(pageViewProvider.notifier).currentPage);
    if (pageViewState.homeTabProfileList.isEmpty) {
      return const Center(
        child: Text(
          'No users as of now...',
          style: CupidStyles.lightTextStyle,
        ),
      );
    }

    return Stack(
      children: [
        PageView(
          padEnds: true,
          key: Key(widget.userProfiles.hashCode.toString()),
          allowImplicitScrolling: false,
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          onPageChanged: (value) async {
            final pageViewController = ref.read(pageViewProvider.notifier);
            ref.read(pageViewProvider.notifier).setCurrentPage(value);
            if (pageViewController.isLastPage) return;
            if (pageViewState.homeTabProfileList.length - value <= 4) {
              ref
                  .read(pageViewProvider.notifier)
                  .setPageNumber(pageViewController.pageNumber + 1);
              final List<UserProfile> users = await userProfileRepo
                  .getPaginatedUsers(pageViewController.pageNumber, {
                'gender': filterStore.interestedInGender.databaseString,
                'program': filterStore.program.databaseString,
                'yearOfJoin': filterStore.yearOfJoin,
                'name': filterStore.name
              });
              if (users.length < 10) {
                ref.read(pageViewProvider.notifier).setIsLastPage(true);
              }
              ref.read(pageViewProvider.notifier).addHomeTabProfiles(users);
            }
          },
          children: List.generate(
            pageViewState.homeTabProfileList.length,
            (index) {
              return DisplayProfileInfo(
                userProfile: pageViewState.homeTabProfileList[index],
              );
            },
          ),
        ),
        Positioned(bottom: 16, right: 16, child: _actionButton(context))
      ],
    );
  }

  FloatingActionButton _actionButton(BuildContext context) {
    final crushesRepo = ref.read(crushesRepoProvider);
    final profile = ref
        .watch(pageViewProvider)
        .homeTabProfileList[ref.read(pageViewProvider.notifier).currentPage];
    return FloatingActionButton(
      backgroundColor: const Color(0xFFFBA8AA),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: const Icon(
        Icons.favorite,
        size: 24,
        color: Colors.white,
      ),
    );
  }
}
