import 'package:blurhash_ffi/blurhashffi_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/global/custom_loader.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserProfileImages extends StatefulWidget {
  const UserProfileImages({
    super.key,
    required this.user,
    this.moveToProfile = true,
    this.height,
  });

  final UserProfile user;
  final bool moveToProfile;
  final double? height;

  @override
  State<UserProfileImages> createState() => _UserProfileImagesState();
}

class _UserProfileImagesState extends State<UserProfileImages> with SingleTickerProviderStateMixin {
  final _controller = PageController();
  var _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page!.toInt();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextImage() async {
    if (widget.user.images.length == 1) return;
    final nextIndex = _controller.page!.toInt() + 1;
    if (nextIndex == widget.user.images.length) return;
    _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void _previousImage() async {
    if (widget.user.images.length == 1) return;
    final previousIndex = _controller.page!.toInt() - 1;
    if (previousIndex < 0) return;
    _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width - 20;
    final height = widget.height ?? width * 4 / 3;
    return Hero(
      tag: 'profilePic',
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.circular(20),
        ),
        child: Stack(
          children: [
            _imagePageView(width, height),
            if (!widget.moveToProfile) _imageNumIndicator(),
            _gestures(),
          ],
        ),
      ),
    );
  }

  Positioned _gestures() {
    return Positioned.fill(
      top: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: widget.moveToProfile
            ? () {
                context.pushNamed(AppRoutes.userProfileScreen.name,
                    extra: {'isMine': false, 'userProfile': widget.user});
              }
            : null,
        behavior: widget.moveToProfile ? HitTestBehavior.opaque : HitTestBehavior.translucent,
        child: !widget.moveToProfile
            ? Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: _previousImage,
                      child: Container(),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: _nextImage,
                      child: Container(),
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Positioned _imageNumIndicator() {
    return Positioned(
      left: 10,
      right: 10,
      top: 10,
      child: Row(
        children: List.generate(widget.user.images.length, (index) {
          final active = index <= _currentPage;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              margin: const EdgeInsets.only(right: 4),
              width: active ? 20 : 10,
              height: 4,
              decoration: BoxDecoration(
                color: active ? Colors.white : Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Container _imagePageView(double width, double? height) {
    return Container(
      width: width,
      height: height,
      foregroundDecoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black],
            begin: Alignment.center,
            end: Alignment.bottomCenter),
      ),
      child: PageView.builder(
        itemBuilder: (context, index) {
          final url = widget.user.images[index].url;
          final blurHash = widget.user.images[index].blurHash;
          return CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: url,
            placeholder: (context, url) {
              if (blurHash == null) return const CustomLoader();
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: width,
                  height: width,
                  child: BlurhashFfi(
                    hash: widget.user.images.first.blurHash!,
                  ),
                ),
              );
            },
          );
        },
        itemCount: widget.user.images.length,
        controller: _controller,
      ),
    );
  }
}
