import 'package:college_cupid/domain/models/event_model.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  String _formatTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final isBlindDating = event.eventType == 'BLIND_DATING';
    final isActive = event.isActive;
    final hasTimeInfo = event.startTime != null && event.endTime != null;
    return Container(
      // // margin: const EdgeInsets.only(bottom: 20),
      // padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // TODO: Add Actual Image when ready
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: CupidColors.cupidPeach,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            event.title,
            style: CupidTextStyles.title2.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            event.description,
            style: CupidTextStyles.body1.copyWith(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),

          // Show time info if available and event is BLIND_DATING
          if (isBlindDating && hasTimeInfo) ...[
            if (isActive)
              // Event is active - show end time
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time, color: Colors.green, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Active until ${_formatTime(event.endTime!)}',
                      style: CupidTextStyles.body2.copyWith(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            else
              // Event is not active - show schedule
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.schedule, color: Colors.orange, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Daily: ${_formatTime(event.startTime!)} - ${_formatTime(event.endTime!)}',
                      style: CupidTextStyles.body2.copyWith(
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
          ],

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isBlindDating && hasTimeInfo
                  ? (isActive ? () => context.pushNamed(AppRoutes.speedDating.name) : null)
                  : () => context.pushNamed(AppRoutes.speedDating.name),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isBlindDating && hasTimeInfo && !isActive ? Colors.grey : CupidColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                isBlindDating && hasTimeInfo
                    ? (isActive ? 'Join Now' : 'Not Active')
                    : event.actionText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
