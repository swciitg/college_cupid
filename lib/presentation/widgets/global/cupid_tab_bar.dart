import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

class CupidTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;
  final Function(int)? onTap;
  final bool isScrollable;

  const CupidTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.onTap,
    this.isScrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: isScrollable,
      indicatorColor: Colors.transparent,
      dividerColor: Colors.transparent,
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      tabAlignment: TabAlignment.start,
      onTap: onTap,
      tabs: tabs.map((title) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final isSelected = controller.index == tabs.indexOf(title);
            return Tab(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? CupidColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : CupidColors.greyColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  title,
                  style: CupidTextStyles.label2.copyWith(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
