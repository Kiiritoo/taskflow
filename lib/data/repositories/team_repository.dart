import '../services/database_service.dart';
import '../models/team.dart';

class TeamRepository {
  final DatabaseService _db;

  TeamRepository(this._db);

  Future<List<Team>> getTeamsByOrganization(int organizationId) async {
    try {
      final conn = await _db.getConnection();
      final results = await conn.query('''
        SELECT t.*, 
               COUNT(tm.id) as member_count
        FROM teams t
        LEFT JOIN team_members tm ON t.id = tm.team_id
        WHERE t.organization_id = ?
        GROUP BY t.id
      ''', [organizationId]);
      
      await conn.close();
      
      return results.map((row) => Team(
        id: row['id'],
        name: row['name'],
        description: row['description'],
        organizationId: row['organization_id'],
        members: [],
      )).toList();
    } catch (e) {
      throw Exception('Failed to load teams: $e');
    }
  }

  Future<Team> createTeam(String name, String? description, int organizationId) async {
    try {
      final conn = await _db.getConnection();
      final result = await conn.query(
        'INSERT INTO teams (name, description, organization_id) VALUES (?, ?, ?)',
        [name, description, organizationId]
      );
      
      final id = result.insertId;
      await conn.close();
      
      return Team(
        id: id!,
        name: name,
        description: description,
        organizationId: organizationId,
        members: [],
      );
    } catch (e) {
      throw Exception('Failed to create team: $e');
    }
  }

  Future<void> addTeamMember(int teamId, int userId, String role) async {
    try {
      final conn = await _db.getConnection();
      await conn.query(
        'INSERT INTO team_members (team_id, user_id, role) VALUES (?, ?, ?)',
        [teamId, userId, role]
      );
      await conn.close();
    } catch (e) {
      throw Exception('Failed to add team member: $e');
    }
  }
}
