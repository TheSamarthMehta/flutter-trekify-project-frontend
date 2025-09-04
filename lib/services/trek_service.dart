// lib/services/trek_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/trek_model.dart';
import '../config/api_config.dart';
import 'dart:developer' as developer;

class TrekService {
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);

  Future<Map<String, dynamic>> fetchTreks() async {
    int retryCount = 0;
    
    while (retryCount < _maxRetries) {
      try {
        developer.log('Attempting to fetch treks (attempt ${retryCount + 1}/$_maxRetries)', name: 'TrekService');
        
        final url = await ApiConfig.getTrekUrl('');
        developer.log('Fetching from URL: $url', name: 'TrekService');
        
        // Create HTTP client with custom timeout
        final client = http.Client();
        
        try {
          final response = await client.get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'User-Agent': 'Trekify/1.0.0',
            },
          ).timeout(
            ApiConfig.connectionTimeout,
            onTimeout: () {
              throw TimeoutException('Request timed out after ${ApiConfig.connectionTimeout.inSeconds} seconds. Please check your internet connection.');
            },
          );

          developer.log('Response status: ${response.statusCode}', name: 'TrekService');
          
          if (response.statusCode == 200) {
            // Parse response
            final Map<String, dynamic> body = jsonDecode(response.body);
            
            if (body['success'] == true && body['data'] is List) {
              final List<dynamic> trekData = body['data'];
              List<Trek> treks = trekData.map((dynamic item) => Trek.fromJson(item)).toList();
              
              developer.log('Successfully fetched ${treks.length} treks', name: 'TrekService');
              return {'success': true, 'data': treks};
            } else {
              developer.log('Server returned unexpected format: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}', name: 'TrekService');
              return {'success': false, 'error': 'Server returned an unexpected data format.'};
            }
          } else if (response.statusCode == 503) {
            // Service unavailable - might be temporary
            developer.log('Server temporarily unavailable (503)', name: 'TrekService');
            return {'success': false, 'error': 'Server is temporarily unavailable. Please try again in a few minutes.'};
          } else if (response.statusCode == 404) {
            developer.log('API endpoint not found (404)', name: 'TrekService');
            return {'success': false, 'error': 'API endpoint not found. Please check server configuration.'};
          } else {
            developer.log('Server error: ${response.statusCode} - ${response.body}', name: 'TrekService');
            return {'success': false, 'error': 'Server error: ${response.statusCode}. Please try again later.'};
          }
        } finally {
          client.close();
        }
        
      } on SocketException catch (e) {
        developer.log('Socket exception: $e', name: 'TrekService');
        if (retryCount < _maxRetries - 1) {
          developer.log('Retrying in ${_retryDelay.inSeconds} seconds...', name: 'TrekService');
          await Future.delayed(_retryDelay);
          retryCount++;
          continue;
        }
        return {'success': false, 'error': 'Could not connect to the server. Please check your internet connection and try again.'};
        
      } on TimeoutException catch (e) {
        developer.log('Timeout exception: $e', name: 'TrekService');
        if (retryCount < _maxRetries - 1) {
          developer.log('Retrying in ${_retryDelay.inSeconds} seconds...', name: 'TrekService');
          await Future.delayed(_retryDelay);
          retryCount++;
          continue;
        }
        return {'success': false, 'error': e.message ?? 'Request timed out. Please check your internet connection and try again.'};
        
      } on FormatException catch (e) {
        developer.log('Format exception: $e', name: 'TrekService');
        return {'success': false, 'error': 'Invalid response format from the server. Please try again later.'};
        
      } catch (e) {
        developer.log('Unexpected error: $e', name: 'TrekService');
        if (retryCount < _maxRetries - 1) {
          developer.log('Retrying in ${_retryDelay.inSeconds} seconds...', name: 'TrekService');
          await Future.delayed(_retryDelay);
          retryCount++;
          continue;
        }
        return {'success': false, 'error': 'An unexpected error occurred: $e'};
      }
    }
    
    return {'success': false, 'error': 'Failed to fetch treks after $_maxRetries attempts. Please check your internet connection and try again.'};
  }

  /// Test network connectivity to the API server
  Future<bool> testConnection() async {
    try {
      final url = await ApiConfig.getTrekUrl('');
      final uri = Uri.parse(url);
      
      developer.log('Testing connection to: ${uri.host}:${uri.port}', name: 'TrekService');
      
      // Test with a simple HEAD request
      final response = await http.head(uri).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Connection test timed out');
        },
      );
      
      final isSuccess = response.statusCode >= 200 && response.statusCode < 500;
      developer.log('Connection test result: ${isSuccess ? "SUCCESS" : "FAILED"} (${response.statusCode})', name: 'TrekService');
      
      return isSuccess;
    } catch (e) {
      developer.log('Connection test failed: $e', name: 'TrekService');
      return false;
    }
  }
}