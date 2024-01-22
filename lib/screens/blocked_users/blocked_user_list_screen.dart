import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/blocked_users_store.dart';
import 'package:college_cupid/widgets/blocked_users/blocked_user_info_tile.dart';
import 'package:college_cupid/widgets/global/app_title.dart';
import 'package:college_cupid/widgets/global/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class BlockedUserListScreen extends StatefulWidget {
  static String id = '/blockedUserListScreen';
  const BlockedUserListScreen({super.key});

  @override
  State<BlockedUserListScreen> createState() => _BlockedUserListScreenState();
}

class _BlockedUserListScreenState extends State<BlockedUserListScreen> {
  @override
  Widget build(BuildContext context) {
    final blockedUsersStore = context.read<BlockedUsersStore>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: CupidColors.pinkColor,
        systemOverlayStyle: CupidStyles.statusBarStyle,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const AppTitle(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Blocked Users',
                style: CupidStyles.headingStyle
                    .copyWith(color: CupidColors.titleColor)),
            Expanded(
                child: FutureBuilder(
              future: blockedUsersStore.getBlockedUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomLoader();
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('There was an error!\nPlease try again'));
                } else {
                  return Observer(
                    builder: (context) {
                      if (blockedUsersStore.blockedUserList.isEmpty) {
                        return const Center(
                          child: Text(
                            'No Blocked Users as of now',
                            textAlign: TextAlign.center,
                            style: CupidStyles.lightTextStyle,
                          ),
                        );
                      }
                      return ListView.builder(
                          itemCount: blockedUsersStore.blockedUserList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return BlockedUserInfoTile(
                              blockedUsersStore: blockedUsersStore,
                              email: blockedUsersStore.blockedUserList[index],
                              index: index,
                            );
                          });
                    },
                  );
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
