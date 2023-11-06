import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/crush_list_store.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:college_cupid/widgets/your_crushes/crush_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../shared/colors.dart';

class YourCrushesTab extends StatefulWidget {
  const YourCrushesTab({super.key});

  @override
  State<YourCrushesTab> createState() => _YourCrushesTabState();
}

class _YourCrushesTabState extends State<YourCrushesTab> {
  final crushListStore = CrushListStore();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 11),
            child: Text('Your Crushes',
                style: CupidStyles.headingStyle
                    .copyWith(color: CupidColors.titleColor)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: const Text(
                'You can select a maximum of 5 crushes at a time.',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: CupidColors.grayColor,
                    fontFamily: 'Sk-Modernist')),
          ),
          Expanded(
              child: FutureBuilder(
            future: crushListStore.getCrushes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Observer(
                  builder: (context) {
                    if (crushListStore.crushList.isEmpty) {
                      return const Center(
                        child: Text('No Crushes as of now\nGet Rolling !!!!'),
                      );
                    }
                    return ListView.builder(
                        itemCount: crushListStore.crushList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CrushInfo(
                            crushListStore: crushListStore,
                            email: Encryption.decryptAES(
                                    encryptedText:
                                        Encryption.hexadecimalToBytes(
                                            crushListStore.crushList[index]
                                                .toString()),
                                    key: LoginStore.password!)
                                .replaceAll('0', ''),
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
    );
  }
}
