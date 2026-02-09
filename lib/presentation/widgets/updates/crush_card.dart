import 'package:blurhash_ffi/blurhashffi_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/presentation/controllers/crushes_controller.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/globals.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/home_tab_provider.dart';
import 'package:college_cupid/stores/page_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class CrushCard extends ConsumerStatefulWidget {
  final UserProfile profile;

  const CrushCard({required this.profile, super.key});

  @override
  ConsumerState<CrushCard> createState() => _CrushCardState();
}

class _CrushCardState extends ConsumerState<CrushCard> {
  bool _isRemoving = false;

  @override
  Widget build(BuildContext context) {
    final program = Program.values.firstWhere((p) => p == widget.profile.program);
    final crushesList = ref.read(crushesControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              spreadRadius: 4,
            )
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Insert profile at the start of home tab profiles
            ref.read(pageViewProvider.notifier).insertProfileAtStart(widget.profile);
            // Switch to home tab (index 0)
            ref.read(homeTabIndexProvider.notifier).state = 0;
            // Force a small delay to ensure state updates before navigation
            Future.microtask(() {
              ref.read(homeTabIndexProvider.notifier).state = 0;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _profileImage(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.profile.name,
                        style: CupidTextStyles.title2.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${program.displayString} '${widget.profile.yearOfJoin}",
                        style: CupidTextStyles.label2,
                      ),
                    ],
                  ),
                ),
                _isRemoving
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: CupidColors.red,
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: () async {
                          setState(() {
                            _isRemoving = true;
                          });
                          try {
                            await crushesList.removeCrush(widget.profile);
                          } catch (e) {
                            if (mounted) {
                              setState(() {
                                _isRemoving = false;
                              });
                              showSnackBar('Failed to remove crush. Please try again.');
                            }
                          }
                        },
                        icon: const Icon(
                          FluentIcons.dismiss_circle_24_filled,
                          color: CupidColors.red,
                          size: 28,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: widget.profile.images.first.url,
        cacheManager: customCacheManager,
        fit: BoxFit.cover,
        height: 80,
        width: 80,
        placeholder: (context, url) => BlurhashFfi(hash: widget.profile.images.first.blurHash!),
        errorWidget: (context, url, error) => Container(
          color: CupidColors.primaryLight,
          child: const Center(
            child: Icon(Icons.person, size: 40, color: CupidColors.primary),
          ),
        ),
      ),
    );
  }
}
