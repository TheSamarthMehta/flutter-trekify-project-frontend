// lib/services/onboarding_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trekify/models/onboarding_info.dart';
import 'package:get/get.dart';
import 'package:trekify/services/auth_service.dart';

class OnboardingService {
  final AuthService _authService = Get.find<AuthService>();

  Future<List<OnboardingInfo>> fetchOnboardingData() async {
    try {
      final response = await http.get(Uri.parse('${_authService.baseUrl}/api/onboarding'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => OnboardingInfo(
          path: json['path'],
          title: json['title'],
          description: json['description'],
          isVideo: json['isVideo'],
        )).toList();
      } else {
        // Handle error or return empty list
        return [];
      }
    } catch (e) {
      // Handle exception
      print("Failed to fetch onboarding data: $e");
      return [];
    }
  }
}