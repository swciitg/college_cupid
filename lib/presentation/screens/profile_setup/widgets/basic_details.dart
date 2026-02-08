import 'package:college_cupid/functions/helpers.dart';
import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/common_widgets.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BasicDetails extends ConsumerStatefulWidget {
  const BasicDetails({super.key});

  @override
  ConsumerState<BasicDetails> createState() => _BasicDetailsState();
}

class _BasicDetailsState extends ConsumerState<BasicDetails> {
  // Controllers for fields present in design but not in current model (Mock integration)
  late TextEditingController _ageController;
  late TextEditingController _zodiacController;
  late TextEditingController _hometownController;

  // Controller for Name (from LoginStore)
  late TextEditingController _nameController;
  late TextEditingController _phnNumberController;
  late TextEditingController _instaController;
  final GlobalKey _zodiacKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: LoginStore.displayName);
    _ageController = TextEditingController();
    _zodiacController = TextEditingController();
    _hometownController = TextEditingController();
    _phnNumberController = TextEditingController();
    _instaController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final onboardingController =
          ref.read(onboardingControllerProvider.notifier);
      // Auto-calculate year of join if possible, or keep existing logic
      if (LoginStore.rollNumber != null) {
        final yearOfJoin = DateTime.now().year % 100 -
            getYearOfJoinFromRollNumber(LoginStore.rollNumber!);
        // log("Year of join : $yearOfJoin");
        onboardingController.updateYearOfJoin(yearOfJoin);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _zodiacController.dispose();
    _hometownController.dispose();
    _phnNumberController.dispose();
    _instaController.dispose();
    super.dispose();
  }

  List<Program> programs =
      Program.values.where((e) => e != Program.none).toList();

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final onboardingController =
        ref.read(onboardingControllerProvider.notifier);

    if (onboardingState.userProfile?.zodiac != null) {
      _zodiacController.text =
          onboardingState.userProfile!.zodiac.displayString;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: "Your Full Name",
          controller: _nameController,
          enabled: false,
        ),
        const SizedBox(height: 16),
        CustomTextField(
            label: "Age",
            hintText: "20", // Placeholder from design
            controller: _ageController,
            keyboardType: TextInputType.number,
            onChanged: (age) {
              onboardingController.updateAge(age);
            }),
        const SizedBox(height: 16),
        CustomTextField(
            label: "Phone Number",
            hintText: "998877XXXX",
            controller: _phnNumberController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            onChanged: (phnNumber) {
              onboardingController.updatePhnNumber(phnNumber);
            }),
        const SizedBox(height: 16),
        CustomTextField(
            label: "Insta Username",
            hintText: "instagram_handle",
            controller: _instaController,
            onChanged: (insta) {
              onboardingController.updateInsta(insta);
            }),
        const SizedBox(height: 16),
        CustomTextField(
          key: _zodiacKey,
          label: "Zodiac",
          hintText: "Select Zodiac",
          controller: _zodiacController,
          readOnly: true,
          suffixIcon: const Icon(Icons.arrow_drop_down,
              color: CupidColors.greySecondary),
          onTap: () async {
            final RenderBox renderBox =
                _zodiacKey.currentContext!.findRenderObject() as RenderBox;
            final overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;

            final RelativeRect position = RelativeRect.fromRect(
              Rect.fromPoints(
                renderBox.localToGlobal(renderBox.size.bottomLeft(Offset.zero),
                    ancestor: overlay),
                renderBox.localToGlobal(renderBox.size.bottomRight(Offset.zero),
                    ancestor: overlay),
              ),
              Offset.zero & overlay.size,
            );

            final Zodiac? result = await showMenu<Zodiac>(
              context: context,
              position: position,
              constraints: BoxConstraints(
                minWidth: renderBox.size.width,
                maxWidth: renderBox.size.width,
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              items: Zodiac.values
                  .map((zodiac) => PopupMenuItem<Zodiac>(
                        value: zodiac,
                        child: Text(
                          zodiac.displayString,
                          style: CupidTextStyles.body1.copyWith(
                            fontSize: 15,
                          ),
                          
                        ),
                      ))
                  .toList(),
            );

            if (result != null) {
              onboardingController.updateZodiac(result);
            }
          },
        ),
        const SizedBox(height: 16),
        const Text("Gender", style: CupidTextStyles.label1),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: Gender.values.map((gender) {
            return SelectionChip(
              label: gender.displayString,
              isSelected: onboardingState.userProfile?.gender == gender,
              onTap: () => onboardingController.updateGender(gender),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: "Hometown",
          hintText: "Banglore",
          controller: _hometownController,
          onChanged: (city) {
            onboardingController.updateHometown(city);
          },
        ),
        const SizedBox(height: 16),
        Text(
          "Degree",
          style:
              CupidTextStyles.label1.copyWith(color: CupidColors.greySecondary),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: programs.map((program) {
            return SelectionChip(
              label: program.displayString,
              isSelected: onboardingState.userProfile?.program == program,
              onTap: () => onboardingController.updateProgram(program),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
