class Habit {
  final int id;
  final String title;
  final String description;
  int streak;
  final String frequency;
  final List<String> completionDays;
  final String color;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.streak,
    required this.frequency,
    required this.completionDays,
    required this.color, // Make sure this is included
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      streak: json['streak'] ?? 0,
      frequency: json['frequency'] ?? 'daily',
      completionDays: List<String>.from(json['completion_days'] ?? []),
      color: json['color'] ?? '#2196F3',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'streak': streak,
      'frequency': frequency,
      'completion_days': completionDays,
      'color': color,
    };
  }
}
