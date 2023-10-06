import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
              image: AssetImage('assets/images/profile_photo.png'))),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadiusDirectional.vertical(bottom: Radius.circular(20)),
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.transparent
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.center
          ),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: SizedBox()),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 8),
              child: Text(
                "Name",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            )
          ]),
      ),
    );
  }
}