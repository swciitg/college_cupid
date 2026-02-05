import 'package:college_cupid/domain/models/confession.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/presentation/widgets/global/cupid_button.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/confessions_controller.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateConfessionScreen extends ConsumerStatefulWidget {
  const CreateConfessionScreen({super.key});

  @override
  ConsumerState<CreateConfessionScreen> createState() => _CreateConfessionScreenState();
}

class _CreateConfessionScreenState extends ConsumerState<CreateConfessionScreen> {
  final TextEditingController _confessionController = TextEditingController();
  ConfessionCategory _selectedCategory = ConfessionCategory.SPOTTED_IN_CAMPUS;
  bool _isLoading = false;

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
          icon: const Icon(FluentIcons.arrow_left_24_regular, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Write your confession',
                      style: CupidTextStyles.brandTitle1,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Share your thoughts anonymously with the IITG community.',
                      style: CupidTextStyles.body1.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Type of confession',
                      style: CupidTextStyles.title2.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _CategoryChip(
                          label: 'Spotted in Campus',
                          isSelected: _selectedCategory == ConfessionCategory.SPOTTED_IN_CAMPUS,
                          onTap: () {
                            setState(() {
                              _selectedCategory = ConfessionCategory.SPOTTED_IN_CAMPUS;
                            });
                          },
                        ),
                        const SizedBox(width: 12),
                        _CategoryChip(
                          label: 'Gossip',
                          isSelected: _selectedCategory == ConfessionCategory.GOSSIP,
                          onTap: () {
                            setState(() {
                              _selectedCategory = ConfessionCategory.GOSSIP;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 150),
                        child: TextField(
                          controller: _confessionController,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            hintText: 'Write your confession here....',
                            hintStyle: CupidTextStyles.title1
                                .copyWith(color: CupidColors.greyColor.withValues(alpha: 0.5)),
                            border: InputBorder.none,
                          ),
                          style: CupidTextStyles.title1.copyWith(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CupidButton(
                      text: _isLoading ? 'Posting...' : 'Post ->',
                      onTap: () async {
                        debugPrint('DEBUG: Tapped Post');
                        debugPrint('DEBUG: Email: ${LoginStore.email}');

                        if (_isLoading) return;
                        if (_confessionController.text.trim().isEmpty) return;

                        setState(() {
                          _isLoading = true;
                        });

                        final success = await ref.read(confessionsProvider.notifier).postConfession(
                              _confessionController.text,
                              _selectedCategory,
                            );

                        debugPrint('DEBUG: Success: $success');
                        if (!success) {
                          debugPrint('DEBUG: Error: ${ref.read(confessionsProvider).errorMessage}');
                        }

                        if (success && mounted) {
                          showSnackBar('Confession Uploaded Successfully!');
                          context.pop();
                        } else if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                          final error = ref.read(confessionsProvider).errorMessage;
                          showSnackBar(error ?? 'Failed to post confession');
                        }
                      },
                      backgroundColor: CupidColors.primary,
                      style: CupidTextStyles.title2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
              isSelected ? CupidColors.primary.withValues(alpha: 0.1) : CupidColors.offWhiteColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: CupidTextStyles.label2.copyWith(
            color: isSelected ? CupidColors.primary : CupidColors.blackColor, // Indigo from SS
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
