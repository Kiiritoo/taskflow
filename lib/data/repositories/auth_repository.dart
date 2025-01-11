import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/database_service.dart';
import 'package:crypto/crypto.dart';
import 'dart:math';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthRepository {
  final SharedPreferences _prefs;
  final DatabaseService _db;

  AuthRepository(this._prefs) : _db = DatabaseService();

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> isLoggedIn() async {
    return _prefs.getString('user_id') != null;
  }

  Future<User?> getCurrentUser() async {
    try {
      final userData = _prefs.getString('user_data');
      if (userData != null) {
        return User.fromJson(jsonDecode(userData));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<User> login(String email, String password) async {
    try {
      final conn = await _db.getConnection();
      final hashedPassword = _hashPassword(password);
      
      final results = await conn.query(
        'SELECT * FROM users WHERE email = ? AND password_hash = ?',
        [email, hashedPassword]
      );
      
      await conn.close();

      if (results.isEmpty) {
        throw Exception('Invalid email or password');
      }

      final userData = results.first;
      final user = User(
        id: userData['id'].toString(),
        fullName: userData['full_name'] ?? '',
        email: userData['email'],
        username: userData['username'],
      );

      await _prefs.setString('user_id', user.id);
      await _prefs.setString('user_data', jsonEncode(user));

      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> register(String fullName, String email, String password) async {
    try {
      final conn = await _db.getConnection();
      final hashedPassword = _hashPassword(password);
      
      await conn.query(
        'INSERT INTO users (full_name, email, username, password_hash) VALUES (?, ?, ?, ?)',
        [fullName, email, email.split('@')[0], hashedPassword]
      );
      
      await conn.close();
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<User> updateProfile(String fullName, String username) async {
    try {
      final conn = await _db.getConnection();
      final userId = _prefs.getString('user_id');
      
      // Check if username is already taken by another user
      final usernameCheck = await conn.query(
        'SELECT id FROM users WHERE username = ? AND id != ?',
        [username, userId]
      );
      
      if (usernameCheck.isNotEmpty) {
        throw Exception('Username already taken');
      }

      // Update user profile
      await conn.query(
        'UPDATE users SET full_name = ?, username = ? WHERE id = ?',
        [fullName, username, userId]
      );
      
      // Get updated user data
      final results = await conn.query(
        'SELECT id, full_name, email, username FROM users WHERE id = ?',
        [userId]
      );
      
      await conn.close();

      if (results.isNotEmpty) {
        final userData = results.first;
        
        // Update stored user data in SharedPreferences
        await _prefs.setString('user_data', jsonEncode({
          'id': userData['id'].toString(),
          'full_name': userData['full_name'],
          'email': userData['email'],
          'username': userData['username'],
        }));

        return User(
          id: userData['id'].toString(),
          fullName: userData['full_name'],
          email: userData['email'],
          username: userData['username'],
        );
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> clearUserData() async {
    await _prefs.clear();
  }

  Future<bool> verifyResetToken(String token) async {
    try {
      final conn = await _db.getConnection();
      final results = await conn.query(
        'SELECT * FROM password_resets WHERE token = ? AND expires_at > NOW()',
        [token]
      );
      await conn.close();
      return results.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to verify reset token: $e');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      final conn = await _db.getConnection();
      final token = _generateResetToken();
      
      await conn.query(
        'INSERT INTO password_resets (email, token, expires_at) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 1 HOUR))',
        [email, token]
      );
      
      await conn.close();
      // TODO: Implement actual email sending
    } catch (e) {
      throw Exception('Failed to send reset email: $e');
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    try {
      final conn = await _db.getConnection();
      final hashedPassword = _hashPassword(newPassword);
      
      final results = await conn.query(
        'SELECT email FROM password_resets WHERE token = ? AND expires_at > NOW()',
        [token]
      );
      
      if (results.isEmpty) {
        throw Exception('Invalid or expired reset token');
      }
      
      final email = results.first['email'];
      
      await conn.query(
        'UPDATE users SET password_hash = ? WHERE email = ?',
        [hashedPassword, email]
      );
      
      await conn.query(
        'DELETE FROM password_resets WHERE token = ?',
        [token]
      );
      
      await conn.close();
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  String _generateResetToken() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  Future<String> uploadProfileImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost/taskflow/api/upload_profile_image.php'),
      );
      
      var file = await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      );
      
      request.files.add(file);
      
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      var jsonData = jsonDecode(response.body);
      
      if (response.statusCode == 200 && jsonData['status'] == 'success') {
        final imageUrl = jsonData['image_url'];
        
        final conn = await _db.getConnection();
        await conn.query(
          'UPDATE users SET profile_image_url = ? WHERE id = ?',
          [imageUrl, _prefs.getString('user_id')],
        );
        await conn.close();
        
        return imageUrl;
      } else {
        throw Exception(jsonData['message'] ?? 'Failed to upload image');
      }
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  // Other methods remain the same...
} 