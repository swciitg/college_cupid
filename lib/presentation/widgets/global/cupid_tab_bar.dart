import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

class CupidTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;
  final Function(int)? onTap;

  const CupidTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade300, // Light border like the image
        ),
      ),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(tabs.length, (index) {
              final isSelected = controller.index == index;
              
              return GestureDetector(
                onTap: () {
                  controller.animateTo(index);
                  if (onTap != null) onTap!(index);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFE94057) : Colors.transparent,
                    borderRadius: _getBorderRadius(index),
                    border: Border(
                      right: (index != tabs.length - 1 && !isSelected && controller.index != index + 1)
                          ? BorderSide(color: Colors.grey.shade300, width: 1)
                          : BorderSide.none,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 10),
                    child: Text(
                      tabs[index],
                      textAlign: TextAlign.center,
                      style: CupidTextStyles.label2.copyWith(
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  BorderRadius _getBorderRadius(int index) {
    if (index == 0) {
      return const BorderRadius.only(
        topLeft: Radius.circular(9),
        bottomLeft: Radius.circular(9),
      );
    } else if (index == tabs.length - 1) {
      return const BorderRadius.only(
        topRight: Radius.circular(9),
        bottomRight: Radius.circular(9),
      );
    }
    return BorderRadius.zero;
  }
}