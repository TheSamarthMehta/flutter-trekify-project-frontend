import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:trekify/config/api_config.dart';

class AuthService {
  Future<Uri> _url(String path) async {
    final baseUrl = await ApiConfig.getAuthUrl(path);
    return Uri.parse(baseUrl);
  }

  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    try {
      final uri = await _url(ApiConfig.authLogin);
      final response = await http.post(
        uri,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final Map<String, dynamic> body = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {'success': true, 'data': body};
      }

      // More comprehensive error handling
      final message = body['message']?.toString().toLowerCase() ?? '';
      
              // Check for account not found scenarios
        if (response.statusCode == 404 || 
            response.statusCode == 401 || 
            response.statusCode == 422 ||
            message.contains('not found') ||
            message.contains('user not found') ||
            message.contains('account not found') ||
            message.contains('email not found') ||
            message.contains('does not exist') ||
            (response.statusCode == 400 && message.contains('invalid email or password'))) {
          return {'success': false, 'code': 'needs_signup', 'message': 'Account not found. Please create a new account.'};
        }

        // Check for invalid password (only when we know the user exists)
        if (response.statusCode == 400 && 
            (message.contains('invalid password') || 
             message.contains('wrong password') ||
             message.contains('incorrect password'))) {
          return {'success': false, 'code': 'invalid_password', 'message': 'Invalid password. Please check your credentials.'};
        }

        // Default error case
        return {'success': false, 'code': 'error', 'message': body['message'] ?? 'Login failed. Please try again.'};
      } catch (e) {
        return {'success': false, 'code': 'error', 'message': 'Network error. Please check your connection.'};
      }
  }

  Future<Map<String, dynamic>> register({required String name, required String email, required String password}) async {
    try {
      final uri = await _url(ApiConfig.authRegister);
      final response = await http.post(
        uri,
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

  Future<Map<String, dynamic>> deleteAccount({required String token}) async {
    try {
      final uri = await _url(ApiConfig.authDeleteAccount);
      final response = await http.delete(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final Map<String, dynamic> body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 204) {
        return {'success': true, 'message': body['message'] ?? 'Account deleted successfully'};
      }
      return {'success': false, 'code': 'error', 'message': body['message'] ?? 'Failed to delete account'};
    } catch (e) {
      return {'success': false, 'code': 'error', 'message': 'Network error. Please check your connection.'};
    }
  }
}