import 'package:college_cupid/domain/models/confession.dart';
import 'package:college_cupid/presentation/widgets/global/cupid_button.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class CreateConfessionScreen extends StatefulWidget {
  const CreateConfessionScreen({super.key});

  @override
  State<CreateConfessionScreen> createState() => _CreateConfessionScreenState();
}

class _CreateConfessionScreenState extends State<CreateConfessionScreen> {
  final TextEditingController _confessionController = TextEditingController();
  ConfessionCategory _selectedCategory = ConfessionCategory.spottedInCampus;
  SongAttachment? _selectedSong; // Null initially

  @override
  void dispose() {
    _confessionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(FluentIcons.arrow_left_24_regular,
              color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Write your confession',
                style: CupidStyles.headingStyle,
              ),
              const SizedBox(height: 8),
              Text(
                'Consequat proident voluptate id adipisicing quis consequat fugiat eu duis velit in ut nisi.',
                style: CupidStyles.lightTextStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 30),
              Text(
                'Type of confession',
                style: CupidStyles.normalTextStyle
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _CategoryChip(
                    label: 'Spotted in Campus',
                    isSelected:
                        _selectedCategory == ConfessionCategory.spottedInCampus,
                    onTap: () {
                      setState(() {
                        _selectedCategory = ConfessionCategory.spottedInCampus;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  _CategoryChip(
                    label: 'Gossip',
                    isSelected: _selectedCategory == ConfessionCategory.gossip,
                    onTap: () {
                      setState(() {
                        _selectedCategory = ConfessionCategory.gossip;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_selectedSong == null)
                GestureDetector(
                  onTap: () {
                    // TODO: Implement song selection
                    setState(() {
                      _selectedSong = SongAttachment(
                          songName: 'Song Name Here', artistName: 'Artist');
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: CupidColors.greyColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(FluentIcons.play_24_filled, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Select Music',
                          style: CupidStyles.normalTextStyle
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: CupidColors.offWhiteColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: CupidColors.greyColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(FluentIcons.music_note_2_24_filled,
                          size: 20, color: CupidColors.cupidGreen),
                      const SizedBox(width: 8),
                      Text(
                        _selectedSong!.songName,
                        style: CupidStyles.normalTextStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          color: CupidColors.cupidGreen,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                          onTap: () {
                            // Change Logic
                          },
                          child: Row(children: [
                            const Icon(FluentIcons.play_24_filled, size: 14),
                            const SizedBox(width: 4),
                            Text("Change",
                                style: CupidStyles.normalTextStyle.copyWith(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                          ])),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSong = null;
                          });
                        },
                        child: Row(
                          children: [
                            Text("Remove",
                                style: CupidStyles.normalTextStyle.copyWith(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(width: 2),
                            const Icon(FluentIcons.dismiss_24_regular,
                                size: 14, color: Colors.red),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              Expanded(
                child: TextField(
                  controller: _confessionController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Write your confession here....',
                    hintStyle: CupidStyles.subHeadingTextStyle.copyWith(
                        color: CupidColors.greyColor.withOpacity(0.5)),
                    border: InputBorder.none,
                  ),
                  style: CupidStyles.subHeadingTextStyle.copyWith(fontSize: 24),
                ),
              ),
              const SizedBox(height: 20),
              CupidButton(
                text: 'Post ->',
                onTap: () {
                  // TODO: Connect to backend
                  Navigator.pop(context);
                },
                backgroundColor: const Color(0xFF8B5CF6),
                style: CupidStyles.normalTextStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color:
              isSelected ? const Color(0xFFE0E7FF) : CupidColors.offWhiteColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: CupidStyles.normalTextStyle.copyWith(
            color: isSelected
                ? const Color(0xFF4F46E5)
                : CupidColors.blackColor, // Indigo from SS
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
