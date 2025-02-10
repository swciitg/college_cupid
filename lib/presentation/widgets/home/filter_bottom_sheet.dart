import 'dart:math';

import 'package:college_cupid/functions/helpers.dart';
import 'package:college_cupid/presentation/widgets/global/cupid_button.dart';
import 'package:college_cupid/presentation/widgets/global/custom_drop_down.dart';
import 'package:college_cupid/presentation/widgets/home/selection_button.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/filter_store.dart';
import 'package:college_cupid/stores/page_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  List<Program> programs = Program.values;
  Map<String, int?> yearOfJoinMap = getYearOfJoinMap();

  var _errorMessage = '';

  final dropDownIcon = Transform.rotate(
    angle: pi / 2,
    child: const Icon(
      Icons.arrow_forward_ios_rounded,
      color: Colors.grey,
      size: 14,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final filterStore = ref.watch(filterProvider);
    final filterController = ref.read(filterProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16).copyWith(
        top: 0,
        bottom: 32,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 5),
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(3),
              ),
              child: const SizedBox(width: 40, height: 3),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                const Center(
                  child: Text('Filters', style: CupidStyles.headingStyle),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      filterController.clearFilters();
                    },
                    child: Text(
                      "Clear",
                      style: CupidStyles.headingStyle.copyWith(
                        color: CupidColors.secondaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Interested in',
            style: CupidStyles.normalTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SelectionButton(
                onTap: () {
                  filterController.setInterestedInGender(InterestedInGender.girls);
                },
                label: InterestedInGender.girls.displayString,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(15),
                ),
                isSelected: filterStore.interestedInGender == InterestedInGender.girls,
              ),
              SelectionButton(
                onTap: () {
                  filterController.setInterestedInGender(InterestedInGender.boys);
                },
                label: InterestedInGender.boys.displayString,
                borderRadius: const BorderRadius.all(Radius.zero),
                isSelected: filterStore.interestedInGender == InterestedInGender.boys,
              ),
              SelectionButton(
                onTap: () {
                  filterController.setInterestedInGender(InterestedInGender.both);
                },
                label: InterestedInGender.both.displayString,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(15),
                ),
                isSelected: filterStore.interestedInGender == InterestedInGender.both,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CustomDropDown(
                items: programs.map((e) => e.displayString).toList(),
                label: 'Programs',
                value: filterStore.program.displayString,
                onChanged: (selectedProgram) {
                  filterController.setProgram(
                      Program.values.firstWhere((p) => p.displayString == selectedProgram));
                  if (selectedProgram == Program.none.displayString) {
                    filterController.setYearOfJoin(null);
                  }
                },
                icon: dropDownIcon,
              ),
              if (ref.watch(filterProvider).program != Program.none) const SizedBox(width: 12),
              if (ref.watch(filterProvider).program != Program.none)
                CustomDropDown(
                  enabled: ref.watch(filterProvider).program != Program.none,
                  items: yearOfJoinMap.keys
                      .toList()
                      .sublist(0, (filterStore.program.numberOfYears ?? 4) + 2),
                  label: "Year of join",
                  value: yearOfJoinMap.keys
                      .firstWhere((key) => yearOfJoinMap[key] == filterStore.yearOfJoin),
                  onChanged: (selectedYear) {
                    if (ref.read(filterProvider).program == Program.none) {
                      setState(() {
                        _errorMessage = "Please select a program!";
                      });
                      return;
                    }
                    filterController.setYearOfJoin(yearOfJoinMap[selectedYear]);
                  },
                  icon: dropDownIcon,
                ),
            ],
          ),
          if (_errorMessage.isNotEmpty) const SizedBox(height: 8),
          if (_errorMessage.isNotEmpty)
            Center(
              child: Text(
                _errorMessage,
                style: CupidStyles.normalTextStyle.setColor(Colors.red),
              ),
            ),
          const SizedBox(height: 16),
          CupidButton(
            text: "Apply",
            onTap: () {
              ref.read(pageViewProvider.notifier).getInitialProfiles();
              Navigator.pop(context);
            },
            backgroundColor: CupidColors.secondaryColor,
          )
        ],
      ),
    );
  }
}
