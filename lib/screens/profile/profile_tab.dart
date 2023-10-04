import 'package:college_cupid/screens/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import '../../shared/colors.dart';

class ProfileTab extends StatefulWidget {
  final bool isMine;
  const ProfileTab({required this.isMine, super.key});

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
          onTap: () {
            if (widget.isMine) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const EditProfile()));
            } else {
              //TODO: Add the person to My Crushes List
            }
          },
        ));
  }

  Widget gridView() {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(8),
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 8 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: List.generate(5, (index) {
          return Container(
            // height: 20,
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.pink,
                spreadRadius: 1,
              )
            ]),
            child: const Center(
              child: Text(
                "Anime",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget aboutMe(var h) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcSTWW4wvzwA9V0xdjG-kF_yXQH__lV5ciORmTPCi4iO6OzxzhJi'),
              fit: BoxFit.cover)),
      child: Column(
        children: [
          SizedBox(
            height: h / 2,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "Id",
                        textAlign: TextAlign.left,
                      ),
                      Expanded(child: SizedBox()),
                      Text(
                        "B.Tech '25",
                        textAlign: TextAlign.right,
                      )
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 8)),
                const Text(
                  "About",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.left,
                ),
                const Padding(padding: EdgeInsets.only(top: 8)),
                SizedBox(
                  height: readMore ? 33 : null,
                  child: const Text(
                      "About me RichText Widget: Allows you to style different parts of the text differently. "
                      "It uses the TextSpan widget to define styled spans of text within the widget.",
                      overflow: TextOverflow.clip),
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
