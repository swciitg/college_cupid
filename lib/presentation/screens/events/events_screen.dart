import 'package:college_cupid/domain/models/event_model.dart';
import 'package:college_cupid/presentation/widgets/events/event_card.dart';
import 'package:college_cupid/repositories/events_repository.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/shared/colors.dart';

import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final eventsProvider = FutureProvider<List<EventModel>>((ref) async {
  final repo = ref.read(eventsRepoProvider);
  return repo.fetchEvents();
});

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsState = ref.watch(eventsProvider);
    final myProfile = ref.watch(userProvider).myProfile;
    final isAdmin = myProfile?.isAdmin ?? false;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Events',
                    style: CupidTextStyles.brandTitle1,
                  ),
                  if (isAdmin)
                    GestureDetector(
                      onTap: () async {
                        await context.pushNamed(AppRoutes.adminEventsManagement.name);
                        // Refresh events after returning from admin screen
                        ref.invalidate(eventsProvider);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(FluentIcons.edit_16_regular, size: 14),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: eventsState.when(
                  data: (events) {
                    // Check if there's a BLIND_DATING event
                    final blindDatingEvent =
                        events.where((e) => e.eventType == 'BLIND_DATING').firstOrNull;

                    // If no BLIND_DATING event exists, show coming soon
                    if (blindDatingEvent == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border_rounded,
                              size: 80,
                              color: CupidColors.primary.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "Blind Dating",
                              style: CupidTextStyles.title1.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Coming Soon",
                              textAlign: TextAlign.center,
                              style: CupidTextStyles.body1.copyWith(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                "Check back later for the next event window!",
                                textAlign: TextAlign.center,
                                style: CupidTextStyles.body2.copyWith(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Show the BLIND_DATING event card
                    return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return EventCard(event: blindDatingEvent);
                      },
                    );
                  },
                  loading: () => const Center(
                      child: CircularProgressIndicator(
                    color: CupidColors.primary,
                  )),
                  error: (e, s) => Center(child: Text('Error: $e')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
