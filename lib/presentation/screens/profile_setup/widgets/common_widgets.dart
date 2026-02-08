import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final int? maxLines;
  final bool? enabled;
  final TextStyle? textStyle;
  final int? maxLength;
  final Function(String)? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label,
              style: CupidTextStyles.label1
                  .copyWith(color: CupidColors.greySecondary)),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            readOnly: readOnly,
            onTap: onTap,
            enabled: enabled,
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLines: maxLines,
            maxLength: maxLength,
            onChanged: onChanged,
            style: textStyle ??
                CupidTextStyles.label2.copyWith(color: CupidColors.grey950),
            decoration: InputDecoration(
              // label: ,
              counter:
                  maxLength != null ? const Text("") : null, //Text("data"),
              hintText: hintText,
              hintStyle:
                  CupidTextStyles.label2.copyWith(color: CupidColors.grey600),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}

class SelectionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;

  const SelectionChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.textStyle,
    this.selectedTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? CupidColors.primaryLight
              : CupidColors.surfaceS2.withValues(alpha: .88),
          borderRadius: BorderRadius.circular(12),
          //border: isSelected ? Border.all(color: const Color(0xFF6C5DD3), width: 1.5) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? CupidColors.primaryDark
                    : CupidColors.greySecondary,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: (isSelected ? selectedTextStyle : textStyle) ??
                  CupidTextStyles.label2.copyWith(
                    color: isSelected
                        ? CupidColors.primaryDark
                        : CupidColors.greySecondary,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavButtons extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback onNext;
  final bool isNextEnabled;
  final String nextLabel;

  const BottomNavButtons({
    super.key,
    this.onBack,
    required this.onNext,
    this.isNextEnabled = true,
    this.nextLabel = 'Next',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          if (onBack != null)
            Expanded(
              flex: 1,
              child: TextButton(
                onPressed: onBack,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CupidColors.surfaceS2,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: CupidColors.borderSecondary,
                      width: 1,
                    ),
                  ),
                  disabledBackgroundColor:
                      const Color(0xFF6C5DD3).withValues(alpha: 0.5),
                ),
                child: Text(
                  'Go Back',
                  style: CupidTextStyles.body1.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (onBack != null) const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: isNextEnabled ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: CupidColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isNextEnabled
                        ? CupidColors.borderPrimary
                        : CupidColors.primary.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                disabledBackgroundColor:
                    const Color(0xFF6C5DD3).withValues(alpha: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nextLabel,
                    style: CupidTextStyles.body1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward,
                      color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProfileProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 4,
            decoration: BoxDecoration(
              color: index <= currentStep
                  ? CupidColors.primary
                  : CupidColors.greyElement,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
