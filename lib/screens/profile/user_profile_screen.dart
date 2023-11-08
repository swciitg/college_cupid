import 'package:college_cupid/functions/diffie_hellman.dart';
import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/models/user_profile.dart';
import 'package:college_cupid/screens/profile/edit_profile.dart';
import 'package:college_cupid/services/api.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter/material.dart';
import '../../shared/colors.dart';

class UserProfileScreen extends StatefulWidget {
  final bool isMine;
  final UserProfile userProfile;

  const UserProfileScreen(
      {required this.isMine, required this.userProfile, super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool readMore = true;
  final defaultPicUrl =
      'https://hips.hearstapps.com/hmg-prod/images/cute-cat-photos-1593441022.jp'
      'g?crop=0.670xw:1.00xh;0.167xw,0&resize=640:*';

  Widget gridView() {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 8 / 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: widget.userProfile.interests.map((interest) {
        return Container(
          // height: 20,
          decoration: BoxDecoration(
              color: CupidColors.backgroundColor,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.pink,
                  spreadRadius: 1,
                )
              ]),
          child: Center(
            child: Text(
              interest,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var safeArea = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CupidColors.backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: CupidColors.titleColor,
        onPressed: () async {
          if (widget.isMine) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EditProfile()));
          } else {
            print(widget.userProfile.publicKey);
            print(LoginStore.dhPrivateKey);
            //TODO: Add the person to My Crushes List
            String sharedSecret = DiffieHellman.generateSharedSecret(
                    otherPublicKey: BigInt.parse(widget.userProfile.publicKey),
                    myPrivateKey: BigInt.parse(LoginStore.dhPrivateKey!))
                .toString();
            String encryptedCrushEmail = Encryption.bytesToHexadecimal(
                Encryption.encryptAES(
                    plainText: widget.userProfile.email,
                    key: LoginStore.password!));

            await APIService().addCrush(sharedSecret, encryptedCrushEmail);
          }
        },
        child: const Icon(
          Icons.favorite,
          size: 30,
        ),
      ),
      body: SingleChildScrollView(
          child: Stack(
        children: [
          Positioned(
              child: Image.network(widget.userProfile.profilePicUrl.isNotEmpty
                  ? widget.userProfile.profilePicUrl
                  : defaultPicUrl)),
          Column(
            children: [
              SizedBox(
                height: safeArea.width * 0.9,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: CupidColors.backgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userProfile.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Text(
                            widget.userProfile.email,
                            textAlign: TextAlign.left,
                          ),
                          const Expanded(child: SizedBox()),
                          Text(
                            '${widget.userProfile.program}, ${widget.userProfile.yearOfStudy.toLowerCase()}',
                            textAlign: TextAlign.right,
                          )
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 8)),
                    const Text(
                      'About',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 8)),
                    SizedBox(
                      height: readMore ? 33 : null,
                      child: Text(widget.userProfile.bio,
                          overflow: TextOverflow.clip),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 8)),
                    if (widget.userProfile.bio.length > 30)
                      GestureDetector(
                        child: Text(
                          !readMore ? "Show less" : "Read more",
                          style: const TextStyle(
                              color: CupidColors.navBarIconColor),
                          textAlign: TextAlign.left,
                        ),
                        onTap: () {
                          setState(() {
                            readMore = !readMore;
                          });
                        },
                      ),
                    const Padding(padding: EdgeInsets.only(top: 8)),
                    const Text(
                      "Interests",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 8)),
                    gridView(),
                  ],
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
