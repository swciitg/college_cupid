import 'package:blurhash_ffi/blurhashffi_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    required this.url,
    required this.blurHash,
    required this.width,
    required this.index,
    this.overlay,
    this.height,
    this.backButton = false,
  });
  final double? height;
  final double width;
  final int index;
  final Widget? overlay;
  final String url;
  final String? blurHash;
  final bool backButton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: width,
            height: height ?? width * 4 / 3,
            foregroundDecoration: BoxDecoration(
              gradient: overlay != null
                  ? const LinearGradient(
                      colors: [Colors.transparent, Colors.black],
                      begin: Alignment.center,
                      end: Alignment.bottomCenter)
                  : null,
            ),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: url,
              placeholder: (context, url) {
                if (blurHash == null) return const CustomLoader();
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: width,
                    height: height ?? width * 4 / 3,
                    child: BlurhashFfi(hash: blurHash!),
                  ),
                );
              },
              errorWidget: (context, url, error) {
                if (blurHash == null) return const CustomLoader();
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: width,
                    height: height ?? width * 4 / 3,
                    child: BlurhashFfi(hash: blurHash!),
                  ),
                );
              },
            ),
          ),
        ),
        if (overlay != null)
          Positioned(
            bottom: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: overlay,
            ),
          ),
        if (backButton)
          Positioned(
            top: 16,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icons/back_icon.svg',
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
