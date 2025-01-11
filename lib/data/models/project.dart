class Project {
  final int id;
  final String name;
  final String? description;
  final int organizationId;
  final String status;
  final DateTime createdAt;

  Project({
    required this.id,
    required this.name,
    this.description,
    required this.organizationId,
    required this.status,
    required this.createdAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      organizationId: json['organization_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'organization_id': organizationId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
