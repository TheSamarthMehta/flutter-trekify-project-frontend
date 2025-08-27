// lib/services/trek_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/trek_model.dart';
import 'dart:developer' as developer;

class TrekService {
  final String _baseUrl = 'http://10.70.19.209:5000/api/data/';

  Future<Map<String, dynamic>> fetchTreks() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl)).timeout(
        const Duration(seconds: 10), // Increased timeout for slower networks
        onTimeout: () {
          throw TimeoutException('The connection has timed out. Please check your IP address and network.');
        },
      );

      if (response.statusCode == 200) {
        // ✅ CORRECTED: Decode the entire object first
        final Map<String, dynamic> body = jsonDecode(response.body);

        // ✅ CORRECTED: Check for success and extract the 'data' list
        if (body['success'] == true && body['data'] is List) {
          final List<dynamic> trekData = body['data'];
          List<Trek> treks = trekData.map((dynamic item) => Trek.fromJson(item)).toList();
          return {'success': true, 'data': treks};
        } else {
          developer.log('Server returned an unexpected data format: $body', name: 'TrekService');
          return {'success': false, 'error': 'Server returned an unexpected data format.'};
        }
      } else {
        return {'success': false, 'error': 'Failed to load treks. Server responded with status code: ${response.statusCode}'};
      }
    } on SocketException {
      return {'success': false, 'error': 'Could not connect to the server. Please check your internet connection and IP address.'};
    } on TimeoutException catch (e) {
      return {'success': false, 'error': e.message ?? 'Request timed out.'};
    } on FormatException {
      return {'success': false, 'error': 'Invalid response format from the server.'};
    } catch (e) {
      return {'success': false, 'error': 'An unexpected error occurred: $e'};
    }
  }
}