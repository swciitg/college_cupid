import 'package:college_cupid/presentation/widgets/blocked_users/blocked_user_info_tile.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/blocked_users_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class BlockedUserListScreen extends StatefulWidget {
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
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: FutureBuilder(
              future: blockedUsersStore.getBlockedUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomLoader();
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text(
                    'Some error occurred!\nPlease try again later!',
                    textAlign: TextAlign.center,
                    style: CupidTextStyles.body1,
                  ));
                } else {
                  return Observer(
                    builder: (context) {
                      if (blockedUsersStore.blockedUserList.isEmpty) {
                        return const Center(
                          child: Text(
                            'No Blocked Users as of now!',
                            textAlign: TextAlign.center,
                            style: CupidTextStyles.body1,
                          ),
                        );
                      }
                      final activeUsers = blockedUsersStore.blockedUserList
                          .where((e) => e != 'deactivatedUser@iitg.ac.in')
                          .toList();
                      return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: activeUsers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return BlockedUserInfoTile(
                              blockedUsersStore: blockedUsersStore,
                              email: activeUsers[index],
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

  AppBar _appBar() {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      title: const Text(
        'Blocked Users',
        style: CupidTextStyles.brandTitle1,
      ),
    );
  }
}
