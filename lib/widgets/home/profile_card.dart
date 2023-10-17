import 'package:flutter/material.dart';

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
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
            image: profilePicUrl == ''
                ? const NetworkImage('')
                : NetworkImage(profilePicUrl),
            fit: BoxFit.cover),
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius:
              BorderRadiusDirectional.vertical(bottom: Radius.circular(20)),
          gradient: LinearGradient(
              stops: [0, 0.6, 1],
              colors: [Colors.transparent, Colors.transparent, Colors.black38],
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
