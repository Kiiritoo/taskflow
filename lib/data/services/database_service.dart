import 'package:mysql1/mysql1.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Future<MySqlConnection> getConnection() async {
    final settings = ConnectionSettings(
      host: '127.0.0.1',
      port: 3306,
      user: 'taskflow',
      password: 'taskflow123',
      db: 'taskflow'
    );
    
    return await MySqlConnection.connect(settings);
  }

  Future<bool> testConnection() async {
    try {
      final conn = await getConnection();
      await conn.close();
      print('Database connection successful!');
      return true;
    } catch (e) {
      print('Database connection failed: $e');
      return false;
    }
  }
}
