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
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: widget.interests.map((interest) {
            return Container(
              height: 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: CupidColors.backgroundColor,
                  boxShadow: const [
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
        const SizedBox(height: 10),
      ],
    );
  }
}
