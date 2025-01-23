Future<Team?> getTeamById(int id) async {
  try {
    final conn = await _db.getConnection();
    final results = await conn.query('''
      SELECT t.*, GROUP_CONCAT(tm.id) as member_ids
      FROM teams t
      LEFT JOIN team_members tm ON t.id = tm.team_id
      WHERE t.id = ?
      GROUP BY t.id
    ''', [id]);

    await conn.close();

    if (results.isEmpty) return null;

    final row = results.first;
    final createdAt = row['created_at'];
    return Team(
      id: row['id'],
      name: row['name'],
      description: row['description'],
      organizationId: row['organization_id'],
      createdAt: createdAt is String ? DateTime.parse(createdAt) : createdAt,
      members: await _getTeamMembers(id),
    );
  } catch (e) {
    throw Exception('Failed to get team: $e');
  }
}
