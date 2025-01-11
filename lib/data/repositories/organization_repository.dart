import '../services/database_service.dart';
import '../models/organization.dart';
import 'dart:convert';

class OrganizationRepository {
  final _db = DatabaseService();

  Future<List<Organization>> getOrganizations() async {
    try {
      final conn = await _db.getConnection();
      final results = await conn.query(
        'SELECT o.*, u.full_name as creator_name '
        'FROM organizations o '
        'LEFT JOIN users u ON o.created_by = u.id'
      );
      
      await conn.close();
      
      return results.map((row) => Organization(
        id: row['id'],
        name: row['name'],
        description: row['description'],
        createdBy: row['created_by'],
        createdAt: row['created_at'],
        teams: [],
        members: [],
      )).toList();
    } catch (e) {
      throw Exception('Failed to load organizations: $e');
    }
  }

  Future<Organization> createOrganization(String name, String? description) async {
    try {
      final conn = await _db.getConnection();
      final result = await conn.query(
        'INSERT INTO organizations (name, description) VALUES (?, ?)',
        [name, description]
      );
      
      final id = result.insertId;
      final createdAt = DateTime.now();
      
      await conn.close();
      
      return Organization(
        id: id!,
        name: name,
        description: description,
        createdBy: 1, // TODO: Get from current user
        createdAt: createdAt,
        teams: [],
        members: [],
      );
    } catch (e) {
      throw Exception('Failed to create organization: $e');
    }
  }

  Future<void> deleteOrganization(int id) async {
    try {
      final conn = await _db.getConnection();
      
      // Start transaction
      await conn.query('START TRANSACTION');
      
      try {
        // Delete related tasks first
        await conn.query(
          'DELETE t FROM tasks t '
          'INNER JOIN projects p ON t.project_id = p.id '
          'WHERE p.organization_id = ?',
          [id]
        );

        // Delete related projects
        await conn.query(
          'DELETE FROM projects WHERE organization_id = ?',
          [id]
        );

        // Finally delete the organization
        await conn.query(
          'DELETE FROM organizations WHERE id = ?',
          [id]
        );

        // Commit transaction
        await conn.query('COMMIT');
      } catch (e) {
        // Rollback on error
        await conn.query('ROLLBACK');
        throw e;
      } finally {
        await conn.close();
      }
    } catch (e) {
      throw Exception('Failed to delete organization: $e');
    }
  }
}
