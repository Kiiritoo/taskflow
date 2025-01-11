class Task {
  final int id;
  final String title;
  final String? description;
  final int projectId;
  final int? assignedTo;
  final String status;
  final DateTime? dueDate;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.projectId,
    this.assignedTo,
    required this.status,
    this.dueDate,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      projectId: json['project_id'],
      assignedTo: json['assigned_to'],
      status: json['status'],
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'project_id': projectId,
      'assigned_to': assignedTo,
      'status': status,
      'due_date': dueDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
