import 'package:college_cupid/functions/diffie_hellman.dart';
import 'package:college_cupid/functions/encryption.dart';
import 'package:college_cupid/models/user_info.dart';
import 'package:college_cupid/screens/profile/edit_profile.dart';
import 'package:college_cupid/services/api.dart';
import 'package:flutter/material.dart';
import '../../shared/colors.dart';

class ProfileTab extends StatefulWidget {
  final bool isMine;
  final UserInfo userInfo;

  const ProfileTab({required this.isMine, required this.userInfo, super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool readMore = true;

  Widget editButton(var w) {
    return Container(
        height: w / 5,
        width: w / 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(w / 10)),
          color: Colors.pinkAccent,
        ),
        child: GestureDetector(
          child: Icon(
            widget.isMine ? Icons.edit : Icons.favorite,
            size: w / 8,
            color: Colors.white,
          ),
          onTap: () async {
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
        ));
  }

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

  Widget aboutMe(var h) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(widget.userInfo.profilePicUrl),
              fit: BoxFit.cover)),
      child: Column(
        children: [
          SizedBox(
            height: h / 2,
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.left,
                ),
                const Padding(padding: EdgeInsets.only(top: 8)),
                SizedBox(
                  height: readMore ? 33 : null,
                  child: Text(widget.userInfo.bio, overflow: TextOverflow.clip),
                ),
                const Padding(padding: EdgeInsets.only(top: 8)),
                GestureDetector(
                  child: Text(
                    !readMore ? "Show less" : "Read more",
                    style: const TextStyle(color: CupidColors.navBarIconColor),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var safeArea = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CupidColors.backgroundColor,
      body: SingleChildScrollView(
          child: Stack(
        children: [
          aboutMe(safeArea.height),
          Positioned(
              left: 2 * safeArea.width / 5,
              top: safeArea.height / 2 - safeArea.width / 10,
              child: editButton(safeArea.width)),
        ],
      )),
    );
  }
}
