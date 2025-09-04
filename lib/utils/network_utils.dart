// lib/utils/network_utils.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../config/api_config.dart';
import 'dart:developer' as developer;

class NetworkUtils {
  /// Check if device has internet connectivity
  static Future<bool> hasInternetConnection() async {
    try {
      // Try to connect to a reliable host
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Test connection to the API server
  static Future<Map<String, dynamic>> testApiConnection() async {
    try {
      developer.log('Testing API connection...', name: 'NetworkUtils');
      
      final url = await ApiConfig.getTrekUrl('');
      final uri = Uri.parse(url);
      
      developer.log('Testing connection to: ${uri.host}:${uri.port}', name: 'NetworkUtils');
      
      // Test with a simple HEAD request
      final response = await http.head(uri).timeout(
        Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Connection test timed out after 15 seconds');
        },
      );
      
      final isSuccess = response.statusCode >= 200 && response.statusCode < 500;
      developer.log('API connection test result: ${isSuccess ? "SUCCESS" : "FAILED"} (${response.statusCode})', name: 'NetworkUtils');
      
      return {
        'success': isSuccess,
        'statusCode': response.statusCode,
        'host': uri.host,
        'port': uri.port,
        'message': isSuccess ? 'Connection successful' : 'Server responded with status ${response.statusCode}',
      };
    } catch (e) {
      developer.log('API connection test failed: $e', name: 'NetworkUtils');
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Connection failed: $e',
      };
    }
  }

  /// Comprehensive network diagnostic
  static Future<Map<String, dynamic>> runNetworkDiagnostic() async {
    developer.log('Running network diagnostic...', name: 'NetworkUtils');
    
    final results = <String, dynamic>{};
    
    // Check basic internet connectivity
    results['hasInternet'] = await hasInternetConnection();
    developer.log('Internet connectivity: ${results['hasInternet'] ? "YES" : "NO"}', name: 'NetworkUtils');
    
    // Test API connection
    results['apiConnection'] = await testApiConnection();
    
    // Get current API configuration
    results['apiConfig'] = {
      'currentBaseUrl': ApiConfig.currentBaseUrl,
      'isProduction': await _getProductionStatus(),
    };
    
    // Platform info
    results['platform'] = {
      'isWeb': false, // Platform.isWeb not available in this context
      'isAndroid': Platform.isAndroid,
      'isIOS': Platform.isIOS,
    };
    
    developer.log('Network diagnostic completed', name: 'NetworkUtils');
    return results;
  }

  /// Get production status from API settings
  static Future<bool> _getProductionStatus() async {
    try {
      // This is a workaround since we can't directly access ApiSettings from here
      // In a real implementation, you might want to expose this through ApiConfig
      return ApiConfig.currentBaseUrl.contains('onrender.com');
    } catch (e) {
      return false;
    }
  }

  /// Show network diagnostic results to user
  static void showNetworkDiagnostic() async {
    final results = await runNetworkDiagnostic();
    
    String message = 'Network Diagnostic Results:\n\n';
    
    // Internet connectivity
    message += '🌐 Internet: ${results['hasInternet'] ? "✅ Connected" : "❌ Not Connected"}\n\n';
    
    // API connection
    final apiResult = results['apiConnection'] as Map<String, dynamic>;
    message += '🔗 API Server: ${apiResult['success'] ? "✅ Reachable" : "❌ Unreachable"}\n';
    if (apiResult['success']) {
      message += '   Status: ${apiResult['statusCode']}\n';
      message += '   Host: ${apiResult['host']}:${apiResult['port']}\n';
    } else {
      message += '   Error: ${apiResult['message']}\n';
    }
    message += '\n';
    
    // Configuration
    final config = results['apiConfig'] as Map<String, dynamic>;
    message += '⚙️ Configuration:\n';
    message += '   Base URL: ${config['currentBaseUrl']}\n';
    message += '   Production: ${config['isProduction'] ? "Yes" : "No"}\n\n';
    
    // Platform
    final platform = results['platform'] as Map<String, dynamic>;
    message += '📱 Platform:\n';
    message += '   Web: ${platform['isWeb'] ? "Yes" : "No"}\n';
    message += '   Android: ${platform['isAndroid'] ? "Yes" : "No"}\n';
    message += '   iOS: ${platform['isIOS'] ? "Yes" : "No"}\n';
    
    Get.dialog(
      AlertDialog(
        title: const Text('Network Diagnostic'),
        content: SingleChildScrollView(
          child: Text(message, style: const TextStyle(fontFamily: 'monospace')),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _showTroubleshootingTips();
            },
            child: const Text('Troubleshoot'),
          ),
        ],
      ),
    );
  }

  /// Show troubleshooting tips
  static void _showTroubleshootingTips() {
    Get.dialog(
      AlertDialog(
        title: const Text('Troubleshooting Tips'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🔧 Common Solutions:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('1. Check your internet connection'),
              Text('2. Try switching between WiFi and mobile data'),
              Text('3. Restart the app'),
              Text('4. Check if the server is running'),
              Text('5. Verify firewall settings'),
              SizedBox(height: 8),
              Text('📱 For Mobile Users:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Ensure app has internet permission'),
              Text('• Try different network (WiFi vs Mobile)'),
              SizedBox(height: 8),
              Text('🌐 For Web Users:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Check browser console for errors'),
              Text('• Try different browser'),
              Text('• Check CORS settings on server'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
