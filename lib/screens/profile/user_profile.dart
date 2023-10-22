import 'package:college_cupid/functions/diffie_hellman.dart';
import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/models/user_info.dart';
import 'package:college_cupid/screens/profile/edit_profile.dart';
import 'package:college_cupid/services/api.dart';
import 'package:flutter/material.dart';
import '../../shared/colors.dart';

class UserProfile extends StatefulWidget {
  final bool isMine;
  final UserInfo userInfo;

  const UserProfile({required this.isMine, required this.userInfo, super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool readMore = true;

  Widget gridView() {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 8 / 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      children: widget.userInfo.interests.map((interest) {
        return Container(
          // height: 20,
          decoration: const BoxDecoration(
              color: CupidColors.backgroundColor,
              boxShadow: [
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
            //TODO: Add the person to My Crushes List
            final df = DiffieHellman();
            String sharedSecret = df
                .getSecretKey(BigInt.parse(widget.userInfo.publicKey))
                .toString();
            String encryptedCrushEmail = Encryption.bytesToHexadecimal(
                Encryption.encryptAES(widget.userInfo.email, 'key'));

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
          Positioned(child: Image.network(widget.userInfo.profilePicUrl)),
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
                      widget.userInfo.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Text(
                            widget.userInfo.email,
                            textAlign: TextAlign.left,
                          ),
                          const Expanded(child: SizedBox()),
                          Text(
                            '${widget.userInfo.program}, ${widget.userInfo.yearOfStudy.toLowerCase()}',
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
                      child: Text(widget.userInfo.bio,
                          overflow: TextOverflow.clip),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 8)),
                    GestureDetector(
                      child: Text(
                        !readMore ? "Show less" : "Read more",
                        style:
                            const TextStyle(color: CupidColors.navBarIconColor),
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
