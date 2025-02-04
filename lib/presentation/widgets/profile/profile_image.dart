import 'package:blurhash_ffi/blurhashffi_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    required this.url,
    required this.blurHash,
    required this.width,
    required this.index,
    this.overlay,
    this.height,
  });
  final double? height;
  final double width;
  final int index;
  final Widget? overlay;
  final String url;
  final String? blurHash;

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
          )
      ],
    );
  }
}
