import 'package:blurhash_ffi/blurhashffi_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
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

class CrushCard extends ConsumerWidget {
  final UserProfile profile;

  const CrushCard({required this.profile, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final program = Program.values.firstWhere((p) => p == profile.program);
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
            ref.read(pageViewProvider.notifier).insertProfileAtStart(profile);
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
                        profile.name,
                        style: CupidTextStyles.title2.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${program.displayString} '${profile.yearOfJoin}",
                        style: CupidTextStyles.label2,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await crushesList.removeCrush(profile);
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
        imageUrl: profile.images.first.url,
        cacheManager: customCacheManager,
        fit: BoxFit.cover,
        height: 80,
        width: 80,
        placeholder: (context, url) => BlurhashFfi(hash: profile.images.first.blurHash!),
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
