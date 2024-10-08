import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final List<String> items;
  final String? hintText;
  final String? label;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final int? index;
  final String? value;
  final BorderRadius? borderRadius;
  final bool? isNecessary;
  final Widget? icon;
  final int? flex;

  const CustomDropDown({
    super.key,
    required this.items,
    this.hintText,
    this.label,
    required this.onChanged,
    this.index,
    this.value,
    this.borderRadius,
    this.validator,
    this.isNecessary = false,
    this.icon,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex!,
      child: DropdownButtonFormField(
        validator: validator ?? (value) => null,
        menuMaxHeight: 300,
        value: value,
        isExpanded: true,
        decoration: InputDecoration(
          hintText: hintText,
          label: hintText == null
              ? RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: label,
                        style: CupidStyles.normalTextStyle
                            .copyWith(color: CupidColors.pinkColor),
                      ),
                      isNecessary!
                          ? TextSpan(
                              text: ' * ',
                              style: CupidStyles.normalTextStyle
                                  .copyWith(color: Colors.red),
                            )
                          : const TextSpan(),
                    ],
                  ),
                )
              : null,
          labelStyle: CupidStyles.normalTextStyle
              .copyWith(color: CupidColors.pinkColor),
          hintStyle: CupidStyles.normalTextStyle
              .copyWith(color: CupidColors.pinkColor),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: CupidColors.pinkColor, width: 1),
            borderRadius: borderRadius ??
                const BorderRadius.all(
                  Radius.circular(15),
                ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: CupidColors.pinkColor, width: 1),
            borderRadius: borderRadius ??
                const BorderRadius.all(
                  Radius.circular(15),
                ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1),
            borderRadius: borderRadius ??
                const BorderRadius.all(
                  Radius.circular(15),
                ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1),
            borderRadius: borderRadius ??
                const BorderRadius.all(
                  Radius.circular(15),
                ),
          ),
        ),
        dropdownColor: CupidColors.offWhiteColor,
        isDense: true,
        icon: icon ??
            const Icon(
              Icons.arrow_drop_down,
              size: 28,
            ),
        elevation: 16,
        style: CupidStyles.normalTextStyle,
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
