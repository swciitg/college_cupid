import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProfileCard extends StatelessWidget {
  final String profilePicUrl;
  final String name;

  const ProfileCard(
      {required this.name, required this.profilePicUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: CupidColors.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(30, 5, 10, 0.3),
              offset: Offset(2, 2),
              blurRadius: 5,
              spreadRadius: 1)
        ],
        image: DecorationImage(
            image: CachedNetworkImageProvider(profilePicUrl),
            fit: BoxFit.cover),
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius:
              BorderRadiusDirectional.vertical(bottom: Radius.circular(20)),
          gradient: LinearGradient(
              stops: [0, 0.6, 1],
              colors: [Colors.transparent, Colors.transparent, Colors.black87],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 8),
            child: SizedBox(
              // width: 120,
              child: Text(
                name.split(' ')[0],
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
