class Task {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String priority;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
    required this.isCompleted,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
      priority: json['priority'] ?? 'medium',
      isCompleted: json['is_completed'] ?? false,
    );
  }
}
