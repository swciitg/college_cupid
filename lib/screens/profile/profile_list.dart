import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import '../../shared/colors.dart';

class ProfileList extends StatefulWidget {
  const ProfileList({super.key});

  @override
  State<ProfileList> createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {

  bool read_more = false;

  Widget likeButton(var w){
    return Container(
      height: w/5,
      width: w/5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(w/10)),
        color: Colors.pinkAccent,
      ),
      child: GestureDetector(
        child:Icon(Icons.favorite,size: w/8,color: Colors.white,),
        onTap: () {
          // like function for your crush
        },
      )
    );
  }


    Widget backButton(var w){
    return Container(
      height: w/8,
      width: w/8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(w/16)),
        color: const Color.fromARGB(255, 208, 199, 199),
      ),
      child: GestureDetector(
        child:Center(child: Padding(
          padding: const EdgeInsets.only(left: 9.7),
          child: Icon(Icons.arrow_back_ios,size: w/12,color: Colors.white,),
        )),
        onTap: () {
            // go back function 
        },
      )
    );
  }

  Widget gridView(){
    return Container(
      height: 100,
      padding: EdgeInsets.all(8),
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 8/2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: List.generate(5, (index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.pink,
                  spreadRadius: 1,
                )
              ]
            ),
            child: Center(
              child: Text("Anime",style: TextStyle(color: Colors.black,),),
            ),
          );
        }),
      ),
    );
  }

  





  Widget aboutMe(var h){
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcSTWW4wvzwA9V0xdjG-kF_yXQH__lV5ciORmTPCi4iO6OzxzhJi'),
          fit: BoxFit.cover
        )
      ),
      child: Column(
        children: [
          SizedBox(
            height: h/2,
          ),

          Container(
            padding: EdgeInsets.all(20),

            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
            ),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Text("Id",textAlign: TextAlign.left,),
                      Expanded(child: SizedBox()),
                      Text("Btech 25",textAlign: TextAlign.right,)
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 8)),
                Text("About",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.left,),
                Padding(padding: EdgeInsets.only(top: 8)),
                // Text(),
               Container(
                        height: !read_more ? 33 : null,
                        child: Text("About me RichText Widget: Allows you to style different parts of the text differently. "
                     "It uses the TextSpan widget to define styled spans of text within the widget.",overflow: TextOverflow.clip,),
                ),
                Padding(padding: EdgeInsets.only(top: 8)),
                GestureDetector(
                  child: Text( read_more ? "Show less":"Read more",style: TextStyle(color: CupidColors.navBarIconColor),textAlign: TextAlign.left,),
                  onTap: () {
                    setState(() {
                      read_more = !read_more;
                    });
                    
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 8)),
                Text("Interests",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                Padding(padding: EdgeInsets.only(top: 8)),
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
     return 
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
       body:
       SingleChildScrollView(
        child: Container(
        // height: double.maxFinite,
        child: Stack(
          children: [
            Padding(padding: EdgeInsets.only(top: 10)),
            aboutMe(safeArea.height),
            Positioned(
                left: 2*safeArea.width/5,
                top: safeArea.height/2-safeArea.width/10,
                child: likeButton(safeArea.width)
            ),
            Positioned(
              left: safeArea.width/12,
              top: safeArea.width/12,
              child: backButton(safeArea.width))
          ],
        ),
      ),
      ),
    );
  }
}
