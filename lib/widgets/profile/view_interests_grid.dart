import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';

class ViewInterestsGrid extends StatefulWidget {
  final List<String> interests;

  const ViewInterestsGrid({required this.interests, super.key});

  @override
  State<ViewInterestsGrid> createState() => _ViewInterestsGridState();
}

class _ViewInterestsGridState extends State<ViewInterestsGrid> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Interests",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        const Padding(padding: EdgeInsets.only(top: 8)),
        Container(
          height: 80,
          padding: const EdgeInsets.all(8),
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: widget.interests.map((interest) {
              return Container(
                height: 20,
                decoration: const BoxDecoration(
                    color: CupidColors.backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink,
                        spreadRadius: 1,
                      ),
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
          ),
        ),
      ],
    );
  }
}
