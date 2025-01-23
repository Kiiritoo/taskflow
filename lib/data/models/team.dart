import '../models/user.dart';

class Team {
  final int id;
  final String name;
  final String? description;
  final int organizationId;
  final DateTime createdAt;
  final List<TeamMember> members;

  Team({
    required this.id,
    required this.name,
    this.description,
    required this.organizationId,
    required this.createdAt,
    this.members = const [],
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      organizationId: json['organization_id'],
      createdAt: json['created_at'] is String
          ? DateTime.parse(json['created_at'])
          : json['created_at'] as DateTime,
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
      'created_at': createdAt.toIso8601String(),
      'members': members.map((member) => member.toJson()).toList(),
    };
  }
}

class TeamMember {
  final int id;
  final int teamId;
  final User? user;
  final String role;
  final DateTime joinedAt;

  TeamMember({
    required this.id,
    required this.teamId,
    this.user,
    required this.role,
    required this.joinedAt,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'],
      teamId: json['team_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      role: json['role'],
      joinedAt: DateTime.parse(json['joined_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'team_id': teamId,
      'user': user?.toJson(),
      'role': role,
      'joined_at': joinedAt.toIso8601String(),
    };
  }
}
