import '../services/database_service.dart';
import '../models/team.dart';
import '../models/user.dart';
import 'package:flutter/foundation.dart';

class TeamRepository {
  final DatabaseService _db;

  TeamRepository(this._db);

  Future<List<Team>> getTeamsByOrganization(int organizationId) async {
    try {
      final conn = await _db.getConnection();
      final userId = 1; // TODO: Get from auth service

      final results = await conn.query('''
        SELECT t.*, COUNT(tm2.id) as member_count
        FROM teams t
        INNER JOIN team_members tm ON t.id = tm.team_id AND tm.user_id = ?
        LEFT JOIN team_members tm2 ON t.id = tm2.team_id
        WHERE t.organization_id = ?
        GROUP BY t.id
      ''', [userId, organizationId]);

      final teams = await Future.wait(results.map((row) async {
        final createdAt = row['created_at'];
        return Team(
          id: row['id'],
          name: row['name'],
          description: row['description'],
          organizationId: row['organization_id'],
          createdAt:
              createdAt is String ? DateTime.parse(createdAt) : createdAt,
          members: await _getTeamMembers(row['id']),
        );
      }));

      await conn.close();
      return teams;
    } catch (e) {
      debugPrint('Error loading teams: $e');
      throw Exception('Failed to load teams: $e');
    }
  }

  Future<Team> createTeam(
      String name, String? description, int organizationId) async {
    try {
      final conn = await _db.getConnection();
      final userId = 1; // TODO: Get from auth service
      late final Team team;

      await conn.transaction((txn) async {
        // Create the team
        final result = await txn.query(
          'INSERT INTO teams (name, description, organization_id) VALUES (?, ?, ?)',
          [name, description, organizationId],
        );

        final teamId = result.insertId;

        // Add the creator as a team member with 'admin' role
        await txn.query(
          'INSERT INTO team_members (team_id, user_id, role) VALUES (?, ?, ?)',
          [teamId, userId, 'admin'],
        );

        // Get the created team
        final teamResult = await txn.query(
          'SELECT * FROM teams WHERE id = ?',
          [teamId],
        );

        final teamData = teamResult.first;
        team = Team(
          id: teamId!,
          name: name,
          description: description,
          organizationId: organizationId,
          createdAt: teamData['created_at'],
          members: [
            TeamMember(
              id: 0,
              teamId: teamId,
              role: 'admin',
              joinedAt: DateTime.now(),
              user: User(
                id: userId.toString(),
                username: '', // TODO: Get from auth service
                email: '', // TODO: Get from auth service
                fullName: '', // TODO: Get from auth service
                profileImageUrl: null,
              ),
            ),
          ],
        );
      });

      await conn.close();
      return team;
    } catch (e) {
      debugPrint('Error creating team: $e');
      throw Exception('Failed to create team: $e');
    }
  }

  Future<void> addTeamMember(int teamId, int userId, String role) async {
    try {
      final conn = await _db.getConnection();
      await conn.query(
          'INSERT INTO team_members (team_id, user_id, role) VALUES (?, ?, ?)',
          [teamId, userId, role]);
      await conn.close();
    } catch (e) {
      throw Exception('Failed to add team member: $e');
    }
  }

  Future<Team?> getTeamById(int id) async {
    try {
      final conn = await _db.getConnection();
      final results = await conn.query('''
        SELECT t.*, COUNT(tm.id) as member_count
        FROM teams t
        LEFT JOIN team_members tm ON t.id = tm.team_id
        WHERE t.id = ?
        GROUP BY t.id
      ''', [id]);

      if (results.isEmpty) {
        await conn.close();
        return null;
      }

      final row = results.first;
      final createdAt = row['created_at'];
      final members = await _getTeamMembers(id);

      final team = Team(
        id: row['id'],
        name: row['name'],
        description: row['description'],
        organizationId: row['organization_id'],
        createdAt: createdAt is String ? DateTime.parse(createdAt) : createdAt,
        members: members,
      );

      await conn.close();
      return team;
    } catch (e) {
      debugPrint('Error getting team: $e');
      throw Exception('Failed to get team: $e');
    }
  }

  Future<List<TeamMember>> _getTeamMembers(int teamId) async {
    try {
      final conn = await _db.getConnection();
      final results = await conn.query('''
        SELECT 
          tm.*,
          u.id as user_id,
          u.username,
          u.email,
          u.full_name,
          u.profile_image_url
        FROM team_members tm
        JOIN users u ON tm.user_id = u.id
        WHERE tm.team_id = ?
      ''', [teamId]);

      await conn.close();

      return results
          .map((row) => TeamMember(
                id: row['id'],
                teamId: row['team_id'],
                role: row['role'],
                joinedAt: row['joined_at'],
                user: User.fromJson({
                  'id': row['user_id'].toString(),
                  'username': row['username'],
                  'email': row['email'],
                  'full_name': row['full_name'] ?? '',
                  'profile_image_url': row['profile_image_url'],
                }),
              ))
          .toList();
    } catch (e) {
      throw Exception('Failed to get team members: $e');
    }
  }
}
