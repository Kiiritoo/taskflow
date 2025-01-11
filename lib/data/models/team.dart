class Team {
  final int id;
  final String name;
  final String? description;
  final int organizationId;
  final List<TeamMember> members;

  Team({
    required this.id,
    required this.name,
    this.description,
    required this.organizationId,
    this.members = const [],
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      organizationId: json['organization_id'],
      members: (json['members'] as List?)
              ?.map((member) => TeamMember.fromJson(member))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'organization_id': organizationId,
      'members': members.map((member) => member.toJson()).toList(),
    };
  }
}

class TeamMember {
  final int userId;
  final String role;

  TeamMember({
    required this.userId,
    required this.role,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      userId: json['user_id'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'role': role,
    };
  }
}
