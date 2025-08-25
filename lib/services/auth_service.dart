// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // ✅ EDITED: Replace "localhost" or the old IP with your computer's current network IP.
  // Make sure your computer and test device are on the same Wi-Fi network.
  final String _baseUrl = 'http://10.93.136.170:5000';

  // A public getter to safely expose the base URL
  String get baseUrl => _baseUrl;

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      return {'statusCode': response.statusCode, 'body': json.decode(response.body)};
    } catch (e) {
      // This is the error you are seeing.
      return {'statusCode': 503, 'body': {'msg': 'Could not connect to the server.'}};
    }
  }

  Future<Map<String, dynamic>> signUp(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );
      return {'statusCode': response.statusCode, 'body': json.decode(response.body)};
    } catch (e) {
      return {'statusCode': 503, 'body': {'msg': 'Could not connect to the server.'}};
    }
  }
}
