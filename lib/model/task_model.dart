class Task {
  final String title;
  final String description;
  final DateTime reminderTime;
  final String recurrenceType;

  Task({
    required this.title,
    required this.description,
    required this.reminderTime,
    required this.recurrenceType,
  });

  // Convert Task to JSON for storage
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'recurrenceType': recurrenceType,
    'reminderTime': reminderTime.toIso8601String(),
  };

  // Create Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) => Task(
    title: json['title'],
    description: json['description'],
    recurrenceType: json['recurrenceType'] ?? "",
    reminderTime: DateTime.parse(json['reminderTime']),
  );
}