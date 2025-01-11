import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';
  
  final http.Client _client;
  
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<http.Response> get(String endpoint, {Map<String, String>? headers}) async {
    return await _client.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
  }

  Future<http.Response> post(String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    return await _client.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {...?headers, 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    return await _client.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {...?headers, 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String endpoint, {Map<String, String>? headers}) async {
    return await _client.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
  }
}
