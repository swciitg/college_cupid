import 'package:flutter/material.dart';
import '../../shared/colors.dart';

class ProfileList extends StatefulWidget {
  const ProfileList({super.key});

  @override
  State<ProfileList> createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  bool readMore = false;

  Widget likeButton(var w) {
    return Container(
        height: w / 5,
        width: w / 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(w / 10)),
          color: Colors.pinkAccent,
        ),
        child: GestureDetector(
          child: Icon(
            Icons.favorite,
            size: w / 8,
            color: Colors.white,
          ),
          onTap: () {
            // like function for your crush
          },
        ));
  }

  Widget backButton(var w) {
    return Container(
        height: w / 8,
        width: w / 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(w / 16)),
          color: const Color.fromARGB(255, 208, 199, 199),
        ),
        child: GestureDetector(
          child: Center(
              child: Padding(
            padding: const EdgeInsets.only(left: 9.7),
            child: Icon(
              Icons.arrow_back_ios,
              size: w / 12,
              color: Colors.white,
            ),
          )),
          onTap: () {
            // go back function
          },
        ));
  }

  Widget gridView() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(8),
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 8 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: List.generate(5, (index) {
          return Container(
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
                        "Btech 25",
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
                // Text(),
                SizedBox(
                  height: !readMore ? 33 : null,
                  child: const Text(
                    "About me RichText Widget: Allows you to style different parts of the text differently. "
                    "It uses the TextSpan widget to define styled spans of text within the widget.",
                    overflow: TextOverflow.clip,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 8)),
                GestureDetector(
                  child: Text(
                    readMore ? "Show less" : "Read more",
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const Padding(padding: EdgeInsets.only(top: 10)),
            aboutMe(safeArea.height),
            Positioned(
                left: 2 * safeArea.width / 5,
                top: safeArea.height / 2 - safeArea.width / 10,
                child: likeButton(safeArea.width)),
            Positioned(
                left: safeArea.width / 12,
                top: safeArea.width / 12,
                child: backButton(safeArea.width))
          ],
        ),
      ),
    );
  }
}
