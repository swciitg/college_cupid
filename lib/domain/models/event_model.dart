class EventModel {
  final String id;
  final String name;
  final String title;
  final String description;
  final String? startTime; // \"23:00\" format
  final String? endTime; // \"02:00\" format
  final String actionText;
  final bool isLive;
  final String? route;
  final String? eventType; // \"BLIND_DATING\", \"SPEED_DATING\", \"OTHER\"

  EventModel({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    this.startTime,
    this.endTime,
    this.actionText = 'View Event',
    required this.isLive,
    this.route,
    this.eventType,
  });

  // Check if event is currently active based on time
  bool get isActive {
    if (startTime == null || endTime == null) return false;

    final now = DateTime.now();
    final currentTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    final start = startTime!.split(':').map(int.parse).toList();
    final end = endTime!.split(':').map(int.parse).toList();
    final current = currentTime.split(':').map(int.parse).toList();

    final startMinutes = start[0] * 60 + start[1];
    final endMinutes = end[0] * 60 + end[1];
    final currentMinutes = current[0] * 60 + current[1];

    // Handle midnight wraparound (e.g., 23:00 to 02:00)
    if (endMinutes < startMinutes) {
      return currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    }

    return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startTime: json['startTime'],
      endTime: json['endTime'],
      actionText: 'View Event',
      isLive: json['isLive'] ?? false,
      route: json['route'],
      eventType: json['event_type'],
    );
  }
}
