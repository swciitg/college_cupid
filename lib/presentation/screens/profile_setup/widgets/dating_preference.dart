import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/common_widgets.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DatingPreferenceScreen extends ConsumerStatefulWidget {
  const DatingPreferenceScreen({super.key});

  @override
  ConsumerState<DatingPreferenceScreen> createState() => _DatingPreferenceScreenState();
}

class _DatingPreferenceScreenState extends ConsumerState<DatingPreferenceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _floatAnimation;
  late Animation<double> _tiltAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -12.0,
      end: 6.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _tiltAnimation = Tween<double>(
      begin: -0.1,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final onboardingController = ref.read(onboardingControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Sexual Orientation",
            style: CupidTextStyles.label1.copyWith(color: CupidColors.greySecondary)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: SexualOrientation.values.map((orientation) {
            return SelectionChip(
              label: orientation.displayString,
              isSelected: onboardingState.userProfile?.sexualOrientation?.type == orientation,
              onTap: () => onboardingController.updateSexualOrientation(orientation),
              textStyle: CupidTextStyles.normalTextStyle.copyWith(color: CupidColors.grey950),
              selectedTextStyle: CupidTextStyles.normalTextStyle.copyWith(
                color: CupidColors.primary,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        Text("Type of Relationship",
            style: CupidTextStyles.label1.copyWith(color: CupidColors.greySecondary)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: LookingFor.values.map((goal) {
            return SelectionChip(
              label: goal.displayString,
              isSelected: onboardingState.userProfile?.relationshipGoal?.goal == goal,
              onTap: () => onboardingController.updateLookingForType(goal),
              textStyle: CupidTextStyles.normalTextStyle.copyWith(color: CupidColors.grey950),
              selectedTextStyle: CupidTextStyles.normalTextStyle.copyWith(
                color: CupidColors.primary,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        _animatedImage(),
      ],
    );
  }

  Align _animatedImage() {
    return Align(
      alignment: Alignment.bottomRight,
      child: SizedBox(
        width: 200,
        height: 200,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value),
              child: Transform.rotate(
                angle: _tiltAnimation.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 180,
                      height: 150,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: CupidColors.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Image.asset(
                        'assets/images/dating_pref_doll.png',
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
