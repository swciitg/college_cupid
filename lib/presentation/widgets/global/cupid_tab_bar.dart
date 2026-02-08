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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(tabs.length, (index) {
              final title = tabs[index];
              final isFirst = index == 0;
              final isLast = index == tabs.length - 1;
              return AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  final isSelected = controller.index == index;
                  return GestureDetector(
                    onTap: () {
                      controller.animateTo(index);
                      onTap?.call(index);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? CupidColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topLeft: isFirst ? const Radius.circular(11) : Radius.zero,
                          bottomLeft: isFirst ? const Radius.circular(11) : Radius.zero,
                          topRight: isLast ? const Radius.circular(11) : Radius.zero,
                          bottomRight: isLast ? const Radius.circular(11) : Radius.zero,
                        ),
                        border: Border.all(
                          color: CupidColors.greyColor.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          title,
                          style: CupidTextStyles.label2.copyWith(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
