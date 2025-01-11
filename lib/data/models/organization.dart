import 'team.dart';

class Organization {
  final int id;
  final String name;
  final String? description;
  final int createdBy;
  final DateTime createdAt;
  final List<Team> teams;
  final List<OrganizationMember> members;

  Organization({
    required this.id,
    required this.name,
    this.description,
    required this.createdBy,
    required this.createdAt,
    this.teams = const [],
    this.members = const [],
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      teams: (json['teams'] as List?)?.map((team) => Team.fromJson(team)).toList() ?? [],
      members: (json['members'] as List?)?.map((member) => OrganizationMember.fromJson(member)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'teams': teams.map((team) => team.toJson()).toList(),
      'members': members.map((member) => member.toJson()).toList(),
    };
  }
}

class OrganizationMember {
  final int userId;
  final String role; // 'ADMIN', 'MANAGER', 'MEMBER'

  OrganizationMember({
    required this.userId,
    required this.role,
  });

  factory OrganizationMember.fromJson(Map<String, dynamic> json) {
    return OrganizationMember(
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
