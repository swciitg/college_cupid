import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:college_cupid/presentation/screens/profile_setup/profilesetup.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/stores/filter_store.dart';
import 'package:college_cupid/stores/page_view_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../shared/colors.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  Timer? timer;
  late FilterStore filterStore;
  late PageViewStore pageViewStore;

  @override
  void dispose() {
    _searchController.dispose();
    filterStore.resetStore();
    pageViewStore.resetStore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfileRepo = ref.read(userProfileRepoProvider);
    filterStore = context.read<FilterStore>();
    pageViewStore = context.read<PageViewStore>();

    return Scaffold(
      backgroundColor: CupidColors.glassWhite,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 35, right: 20),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CupidColors.glassWhite,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black87.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(2),
                    child: InkWell(
                      onTap: (){
                      },
                      child: SvgPicture.asset(
                        "assets/icons/cupid.svg",
                        height: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: CupidColors.glassWhite, // Background color
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Color(0x4DEAE27A), // Suffix icon color
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: CupidColors.blackColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(  // Wrap the scrollable content with Expanded
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        children: [
                          Container(
                            height: 514,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/profilepic.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Container(
                              height: 47,
                              width: 47,
                              decoration: BoxDecoration(
                                color: CupidColors.semiGlasswhite,
                                borderRadius: BorderRadius.circular(47 / 2),
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/back_icon.svg",
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              decoration: BoxDecoration(
                                color: CupidColors.semiGlasswhite,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'short term open for long',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Aditi',
                                style: TextStyle(
                                  color: CupidColors.textColorBlack,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  _buildChip("b.des 2", CupidColors.cupidBlue),
                                  const SizedBox(width: 10),
                                  _buildChip("straight", CupidColors.cupidYellow),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15, bottom: 15),
                            child: _buildPercentageIndicator(80),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: CupidColors.glassWhite,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(50),
                            topLeft: Radius.circular(50),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black87.withOpacity(0.2),
                              spreadRadius: 0,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.0,
                            vertical: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                "I’ve always wanted to learn how to play guitar—it's expressive, freeing, and perfect for campfire sing-alongs with friends.",
                                style: TextStyle(
                                  color: CupidColors.textColorBlack,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}


_buildChip(String label,Color color){
  return Chip(
    label: Text(label),
    backgroundColor: color,
    labelStyle: const TextStyle(color: CupidColors.textColorBlack),
    side: BorderSide.none,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
    ),
  );
}

_buildPercentageIndicator(double percentage){
  return SizedBox(
    height: 60,
    width: 60,
    child: CustomPaint(
      painter: _SemiCirclePainter(percentage),
      child: Center(
        child: Text.rich(
          TextSpan(
            text: "${percentage.toInt()}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CupidColors.textColorBlack,
            ),
            children: const [
              TextSpan(
                text: "%",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: CupidColors.textColorBlack,
                ),
              )
            ]
          )
        ),
      ),
    ),
  );
}

class _SemiCirclePainter extends CustomPainter {
  final double percentage;

  _SemiCirclePainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.transparent
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    Paint progressPaint = Paint()
      ..color = const Color(0x807AEAA9)  //TODO to change color dynamically according to the given percentage
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    double radius = min(size.width / 2, size.height / 2);

    // Define the bounds for the arc
    Rect rect = Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius);

    // Draw the background arc (complete circle for 100%)
    canvas.drawArc(
      rect,
      pi * .75,  // Starting angle (to create a 75% semicircle style)
      pi * 2,  // Sweep angle (draws 75% of the circle)
      false,
      paint,
    );

    // Draw the progress arc based on the percentage
    canvas.drawArc(
      rect,
      pi * 0.75,  // Starting angle (same as above)
      pi * 2 * (percentage / 100),  // Sweep angle proportional to the percentage
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}