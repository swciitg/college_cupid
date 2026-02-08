import 'dart:async';
import 'package:college_cupid/domain/models/event_model.dart';
import 'package:college_cupid/repositories/events_repository.dart';
import 'package:college_cupid/repositories/storage_provider.dart';
import 'package:college_cupid/shared/assets.dart';
import 'package:college_cupid/stores/home_tab_provider.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:college_cupid/routing/app_router.dart';

class EventUpdateMessageCard extends ConsumerStatefulWidget {
  final bool isLive;
  const EventUpdateMessageCard({super.key, required this.isLive});

  @override
  ConsumerState<EventUpdateMessageCard> createState() =>
      _EventUpdateMessageCardState();
}

class _EventUpdateMessageCardState extends ConsumerState<EventUpdateMessageCard>
    with SingleTickerProviderStateMixin {
  bool _isVisible = true;
  int _currentPage = 0;
  Timer? _timer;
  late AnimationController _iconController;
  late Animation<double> _iconAnimation;
  bool _isReverse = false;

  @override
  void initState() {
    super.initState();
    _iconController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..repeat(reverse: true);
    _iconAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
        CurvedAnimation(parent: _iconController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _iconController.dispose();
    super.dispose();
  }

  void _markEventAsSeen(String eventId) {
    ref.read(storageRepositoryProvider).markEventAsViewed(eventId);
  }

  void _startAutoScroll(List<EventModel> events) {
    _timer?.cancel();
    if (events.isNotEmpty) {
      _markEventAsSeen(events[_currentPage].id);
    }

    if (events.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        if (mounted) {
          _nextPage(events, auto: true);
        }
      });
    }
  }

  void _nextPage(List<EventModel> events, {bool auto = false}) {
    if (!auto) _timer?.cancel();
    setState(() {
      _isReverse = false;
      if (_currentPage < events.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
    });
    _markEventAsSeen(events[_currentPage].id);
    if (!auto) _startAutoScroll(events);
  }

  void _prevPage(List<EventModel> events) {
    _timer?.cancel();
    setState(() {
      _isReverse = true;
      if (_currentPage > 0) {
        _currentPage--;
      } else {
        _currentPage = events.length - 1;
      }
    });
    _markEventAsSeen(events[_currentPage].id);
    _startAutoScroll(events);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLive || !_isVisible) {
      return const SizedBox.shrink();
    }

    final eventsAsyncValue = ref.watch(eventsFutureProvider);

    return eventsAsyncValue.when(
      data: (events) {
        if (events.isEmpty) return const SizedBox.shrink();

        if (_timer == null || !_timer!.isActive) {
          _startAutoScroll(events);
        }

        return GestureDetector(
          onTap: () {
            final event = events[_currentPage];
            if (event.route != null) {
              final routeName = event.route!.startsWith('/')
                  ? event.route!.substring(1)
                  : event.route!;

              final isAppRoute =
                  AppRoutes.values.any((e) => e.name == routeName);

              if (isAppRoute) {
                context.pushNamed(routeName);
                return;
              }
            }
            ref.read(homeTabIndexProvider.notifier).state = 3;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RotationTransition(
                  turns: _iconAnimation,
                  child: SvgPicture.asset(
                    CupidIcons.newEventUpdateIcon,
                    height: 70,
                    width: 70,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: CupidColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: CupidColors.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if (details.primaryVelocity! > 0) {
                              _prevPage(events);
                            } else if (details.primaryVelocity! < 0) {
                              _nextPage(events);
                            }
                          },
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 150),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              final inAnimation = Tween<Offset>(
                                      begin:
                                          Offset(_isReverse ? -1.0 : 1.0, 0.0),
                                      end: Offset.zero)
                                  .animate(animation);
                              final outAnimation = Tween<Offset>(
                                      begin:
                                          Offset(_isReverse ? 1.0 : -1.0, 0.0),
                                      end: Offset.zero)
                                  .animate(animation);

                              if (child.key == ValueKey<int>(_currentPage)) {
                                return SlideTransition(
                                    position: inAnimation, child: child);
                              } else {
                                return SlideTransition(
                                    position: outAnimation, child: child);
                              }
                            },
                            child: Container(
                              key: ValueKey<int>(_currentPage),
                              padding: const EdgeInsets.all(16.0),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    events[_currentPage].title.isNotEmpty
                                        ? events[_currentPage].title
                                        : events[_currentPage].name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: CupidTextStyles.body1.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    events[_currentPage].description,
                                    style: CupidTextStyles.body2.copyWith(
                                      color:
                                          Colors.white.withValues(alpha: 0.9),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isVisible = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
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
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}
