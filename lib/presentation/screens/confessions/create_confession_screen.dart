import 'package:college_cupid/domain/models/confession.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/presentation/widgets/global/cupid_button.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/confessions_controller.dart';
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.arrow_back, size: 18, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 8),
        
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Write your confession',
                style: CupidTextStyles.brandTitle1,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'From secret crushes to campus gossip, say it all anonymously.',
                style: CupidTextStyles.body1.copyWith(fontSize: 14,color: CupidColors.greySecondary),
              ),
            ),
            const SizedBox(height: 16),
        
            const Divider(color: CupidColors.borderSecondary,),
            const SizedBox(height: 16,),
        
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Type of confession',
                style: CupidTextStyles.label1.copyWith(color: CupidColors.greySecondary),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  _CategoryChip(
                    label: 'Spotted in Campus',
                    isSelected: _selectedCategory == ConfessionCategory.SPOTTED_IN_CAMPUS,
                    onTap: () => setState(() => _selectedCategory = ConfessionCategory.SPOTTED_IN_CAMPUS),
                  ),
                  const SizedBox(width: 12),
                  _CategoryChip(
                    label: 'Gossip',
                    isSelected: _selectedCategory == ConfessionCategory.GOSSIP,
                    onTap: () => setState(() => _selectedCategory = ConfessionCategory.GOSSIP),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0,horizontal: 20),
                child: TextField(
                  controller: _confessionController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Write your confession here....',
                    hintStyle: CupidTextStyles.title1.copyWith(
                      color: CupidColors.greyTertiary,
                      fontSize: 25
                    ),
                    border: InputBorder.none,
                  ),
                  style: CupidTextStyles.title1.copyWith(fontSize: 24),
                ),
              ),
            ),
        
             const Divider(color: CupidColors.borderSecondary,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CupidButton(
                text: _isLoading ? 'Posting...' : 'Post',
                onTap: _handlePost,
                backgroundColor: CupidColors.primary,
                style: CupidTextStyles.label1.copyWith(
                  color: CupidColors.whitePrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }
  
  Future<void> _handlePost() async {
    if (_isLoading || _confessionController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    final success = await ref.read(confessionsProvider.notifier).postConfession(
          _confessionController.text,
          _selectedCategory,
        );

    if (success && mounted) {
      showSnackBar('Confession Uploaded Successfully!');
      context.pop();
    } else if (mounted) {
      setState(() => _isLoading = false);
      final error = ref.read(confessionsProvider).errorMessage;
      showSnackBar(error ?? 'Failed to post confession');
    }
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? CupidColors.primaryLight
              : CupidColors.offWhiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: CupidTextStyles.label2.copyWith(
            color: isSelected
                ? CupidColors.primaryDark
                : CupidColors.greySecondary, // Indigo from SS
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
