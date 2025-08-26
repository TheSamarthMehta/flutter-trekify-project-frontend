import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseHost = 'http://192.168.1.103:5000';

  Uri _url(String path) => Uri.parse('$_baseHost$path');

  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    try {
      final response = await http.post(
        _url('/api/auth/login'),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final Map<String, dynamic> body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'data': body};
      }

      // Treat 404/401 as needs signup or invalid creds
      if (response.statusCode == 404 || (body['message']?.toString().toLowerCase().contains('not found') ?? false)) {
        return {'success': false, 'code': 'needs_signup', 'message': body['message'] ?? 'Account not found'};
      }

      return {'success': false, 'code': 'error', 'message': body['message'] ?? 'Login failed'};
    } catch (e) {
      return {'success': false, 'code': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> register({required String name, required String email, required String password}) async {
    try {
      final response = await http.post(
        _url('/api/auth/register'),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      final Map<String, dynamic> body = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return {'success': true, 'data': body};
      }
      return {'success': false, 'code': 'error', 'message': body['message'] ?? 'Registration failed'};
    } catch (e) {
      return {'success': false, 'code': 'error', 'message': e.toString()};
    }
  }
}