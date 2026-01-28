import 'package:college_cupid/domain/models/event_model.dart';
import 'package:college_cupid/presentation/widgets/events/event_card.dart';
import 'package:college_cupid/repositories/events_repository.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventsProvider = FutureProvider<List<EventModel>>((ref) async {
  final repo = ref.read(eventsRepoProvider);
  return repo.fetchEvents();
});

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsState = ref.watch(eventsProvider);

    return Scaffold(
      backgroundColor: CupidColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Events',
                style: CupidStyles.headingStyle,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: eventsState.when(
                  data: (events) {
                    if (events.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.event_busy_rounded, 
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No events right now,\ntune in later",
                              textAlign: TextAlign.center,
                              style: CupidStyles.lightTextStyle
                                  .copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return EventCard(event: events[index]);
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
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
