import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/trek_model.dart';

class TrekService {
  // ✅ EDITED: Corrected the IP address typo. Please verify this is your computer's actual IP.
  final String _baseUrl = 'https://flutter-trekify-project-backend.onrender.com/api/data/';

  Future<Map<String, dynamic>> fetchTreks() async {
    try {
      // ✅ EDITED: Reduced the timeout from 10 to 5 seconds for a faster failure response.
      final response = await http.get(Uri.parse(_baseUrl)).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('The connection has timed out. Please check your IP address and network.');
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Trek> treks = body.map((dynamic item) => Trek.fromJson(item)).toList();
        return {'success': true, 'data': treks};
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
