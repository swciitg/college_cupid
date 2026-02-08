class EventModel {
  final String id;
  final String name;
  final String title;
  final String description;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String actionText;
  final bool isLive;
  final String? route;

  EventModel({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    this.startsAt,
    this.endsAt,
    this.actionText = 'View Event',
    required this.isLive,
    this.route,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    DateTime? start =
        json['startsAt'] != null ? DateTime.parse(json['startsAt']) : null;
    DateTime? end =
        json['endsAt'] != null ? DateTime.parse(json['endsAt']) : null;
    final now = DateTime.now();

    bool live = true;
    if (start != null && end != null) {
      live = now.isAfter(start) && now.isBefore(end);
    } else if (start != null) {
      live = now.isAfter(start);
    }

    return EventModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startsAt: start,
      endsAt: end,
      actionText: 'View Event', // Default
      isLive: live,
      route: json['route'],
    );
  }
}
