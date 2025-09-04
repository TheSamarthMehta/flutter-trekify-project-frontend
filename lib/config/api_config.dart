import 'dart:io';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'api_settings.dart';

class ApiConfig {
  // Environment-based configuration
  static const String _defaultBaseUrl = 'http://localhost:5000';
  
  // Network detection and fallback IPs
  static List<String> get _fallbackIPs => [
    ApiSettings.serverIP,  // Your configured IP
    ...ApiSettings.customFallbackIPs,  // Custom fallbacks
  ];
  
  static int get _port => ApiSettings.serverPort;
  
  // Cache the detected base URL
  static String? _cachedBaseUrl;
  static DateTime? _cacheTimestamp;
  
  /// Get the base URL for API calls
  /// Automatically detects the correct IP address or uses fallbacks
  static Future<String> get baseUrl async {
    // Check if we should use production URL
    if (ApiSettings.isProduction) {
      return ApiSettings.productionUrl;
    }
    
    // Check cache validity
    if (_cachedBaseUrl != null && _cacheTimestamp != null) {
      final cacheAge = DateTime.now().difference(_cacheTimestamp!);
      if (cacheAge.inMinutes < ApiSettings.cacheExpirationMinutes) {
        return _cachedBaseUrl!;
      }
    }
    
    // If auto-detection is disabled, use configured IP
    if (!ApiSettings.enableAutoDetection) {
      _cachedBaseUrl = ApiSettings.developmentUrl;
      _cacheTimestamp = DateTime.now();
      return _cachedBaseUrl!;
    }
    
    // Web platform handling - use configured IP directly
    if (kIsWeb) {
      _cachedBaseUrl = ApiSettings.developmentUrl;
      _cacheTimestamp = DateTime.now();
      if (ApiSettings.enableDebugLogging) {
        print('🌐 Web platform detected - using configured IP: ${ApiSettings.serverIP}');
      }
      return _cachedBaseUrl!;
    }
    
    // Try to detect the local network IP (mobile/desktop only)
    if (ApiSettings.enableNetworkDetection && !kIsWeb) {
      final detectedIP = await _detectLocalIP();
      if (detectedIP != null) {
        _cachedBaseUrl = 'http://$detectedIP:$_port';
        _cacheTimestamp = DateTime.now();
        return _cachedBaseUrl!;
      }
    }
    
    // Use fallback IPs if enabled (mobile/desktop only)
    if (ApiSettings.enableFallbacks && !kIsWeb) {
      for (final ip in _fallbackIPs) {
        if (ApiSettings.testConnectionBeforeUse) {
          if (await _isIPReachable(ip)) {
            _cachedBaseUrl = 'http://$ip:$_port';
            _cacheTimestamp = DateTime.now();
            return _cachedBaseUrl!;
          }
        } else {
          // Skip connection testing, use first fallback
          _cachedBaseUrl = 'http://$ip:$_port';
          _cacheTimestamp = DateTime.now();
          return _cachedBaseUrl!;
        }
      }
    }
    
    // Final fallback to configured IP
    _cachedBaseUrl = ApiSettings.developmentUrl;
    _cacheTimestamp = DateTime.now();
    return _cachedBaseUrl!;
  }
  
  /// Manually set a specific IP address
  static void setCustomIP(String ip) {
    _cachedBaseUrl = 'http://$ip:$_port';
    _cacheTimestamp = DateTime.now();
    if (ApiSettings.enableDebugLogging) {
      print('🔧 API IP manually set to: $ip');
    }
  }
  
  /// Reset to auto-detection
  static void resetToAutoDetection() {
    _cachedBaseUrl = null;
    _cacheTimestamp = null;
    if (ApiSettings.enableDebugLogging) {
      print('🔄 Reset to automatic IP detection');
    }
  }
  
  /// Get current base URL (synchronous, returns cached value or default)
  static String get currentBaseUrl {
    return _cachedBaseUrl ?? ApiSettings.developmentUrl;
  }
  
  /// Detect local network IP address (mobile/desktop only)
  static Future<String?> _detectLocalIP() async {
    if (kIsWeb) {
      if (ApiSettings.enableDebugLogging) {
        print('🌐 Web platform - skipping network interface detection');
      }
      return null;
    }
    
    try {
      final interfaces = await NetworkInterface.list();
      
      for (final interface in interfaces) {
        // Skip interfaces based on settings
        if (ApiSettings.skipVirtualInterfaces && 
            (interface.name.toLowerCase().contains('vmware') ||
             interface.name.toLowerCase().contains('virtual') ||
             interface.name.toLowerCase().contains('loopback'))) {
          continue;
        }
        
        // Check if this is a preferred interface
        bool isPreferred = ApiSettings.preferredInterfaces.isEmpty ||
            ApiSettings.preferredInterfaces.any((name) => 
                interface.name.toLowerCase().contains(name.toLowerCase()));
        
        for (final addr in interface.addresses) {
          // Look for IPv4 addresses in common private ranges
          if (addr.type == InternetAddressType.IPv4) {
            final ip = addr.address;
            if (_isPrivateIP(ip)) {
              if (ApiSettings.enableDebugLogging) {
                print('🔍 Detected IP: $ip on interface: ${interface.name}');
              }
              // Return preferred interface IPs first
              if (isPreferred) {
                return ip;
              }
            }
          }
        }
      }
    } catch (e) {
      if (ApiSettings.enableDebugLogging) {
        print('Error detecting local IP: $e');
      }
    }
    return null;
  }
  
  /// Check if IP is in private range
  static bool _isPrivateIP(String ip) {
    final parts = ip.split('.');
    if (parts.length != 4) return false;
    
    final first = int.tryParse(parts[0]) ?? 0;
    final second = int.tryParse(parts[1]) ?? 0;
    
    // 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16
    return (first == 10) ||
           (first == 172 && second >= 16 && second <= 31) ||
           (first == 192 && second == 168);
  }
  
  /// Check if an IP address is reachable (mobile/desktop only)
  static Future<bool> _isIPReachable(String ip) async {
    if (kIsWeb) {
      if (ApiSettings.enableDebugLogging) {
        print('🌐 Web platform - skipping connection test to $ip');
      }
      return false;
    }
    
    try {
      final socket = await Socket.connect(ip, _port, 
          timeout: Duration(seconds: ApiSettings.connectionTestTimeout));
      await socket.close();
      if (ApiSettings.enableDebugLogging) {
        print('✅ Connection test successful to $ip:$_port');
      }
      return true;
    } catch (e) {
      if (ApiSettings.enableDebugLogging) {
        print('❌ Connection test failed to $ip:$_port: $e');
      }
      return false;
    }
  }
  
  // API endpoints
  static const String authLogin = '/api/auth/login';
  static const String authRegister = '/api/auth/register';
  static const String trekData = '/api/data/';
  
  // Helper method to get full URL for auth endpoints
  static Future<String> getAuthUrl(String endpoint) async {
    final base = await baseUrl;
    return '$base$endpoint';
  }
  
  // Helper method to get full URL for trek endpoints
  static Future<String> getTrekUrl(String endpoint) async {
    final base = await baseUrl;
    return '$base$trekData$endpoint';
  }
  
  // Synchronous versions for backward compatibility
  static String getAuthUrlSync(String endpoint) => '$currentBaseUrl$endpoint';
  static String getTrekUrlSync(String endpoint) => '$currentBaseUrl$trekData$endpoint';
  
  // Timeout configurations
  static Duration get connectionTimeout => Duration(seconds: ApiSettings.connectionTimeoutSeconds);
  static Duration get receiveTimeout => Duration(seconds: ApiSettings.receiveTimeoutSeconds);
  
  /// Print current configuration for debugging
  static void printConfig() {
    print('🌐 API Configuration:');
    print('   Platform: ${kIsWeb ? "Web" : "Mobile/Desktop"}');
    print('   Environment: ${ApiSettings.isProduction ? "Production" : "Development"}');
    print('   Current Base URL: $currentBaseUrl');
    print('   Port: $_port');
    print('   Auto-detection: ${ApiSettings.enableAutoDetection ? "Enabled" : "Disabled"}');
    print('   Fallbacks: ${ApiSettings.enableFallbacks ? "Enabled" : "Disabled"}');
    print('   Fallback IPs: ${_fallbackIPs.join(', ')}');
    print('   Cache: ${_cachedBaseUrl != null ? "Valid (${_cacheTimestamp != null ? DateTime.now().difference(_cacheTimestamp!).inMinutes : 0} min old)" : "None"}');
  }
}

/// Simple utility class to manage API configuration
class ApiConfigManager {
  /// Set a custom IP address for the API
  /// Usage: ApiConfigManager.setIP('192.168.1.100')
  static void setIP(String ip) {
    ApiConfig.setCustomIP(ip);
    print('✅ API IP set to: $ip');
  }
  
  /// Reset to automatic IP detection
  static void resetToAuto() {
    ApiConfig.resetToAutoDetection();
    print('🔄 Reset to automatic IP detection');
  }
  
  /// Show current API configuration
  static void showConfig() {
    ApiConfig.printConfig();
  }
  
  /// Test connection to a specific IP (mobile/desktop only)
  static Future<bool> testConnection(String ip) async {
    if (kIsWeb) {
      print('🌐 Web platform - connection testing not supported');
      return false;
    }
    
    try {
      final socket = await Socket.connect(ip, ApiSettings.serverPort, 
          timeout: Duration(seconds: 3));
      await socket.close();
      print('✅ Connection successful to $ip:${ApiSettings.serverPort}');
      return true;
    } catch (e) {
      print('❌ Connection failed to $ip:${ApiSettings.serverPort}: $e');
      return false;
    }
  }
  
  /// Quick setup for common network scenarios
  static void quickSetup() {
    print('🚀 Quick API Setup:');
    if (kIsWeb) {
      print('🌐 Web platform detected:');
      print('   1. Edit lib/config/api_settings.dart');
      print('   2. Change: static const String serverIP = "your-server-ip";');
      print('   3. Make sure your server is accessible from web browsers');
      print('   4. Check CORS settings on your server');
    } else {
      print('📱 Mobile/Desktop platform:');
      print('   1. For home network: ApiConfigManager.setIP("192.168.1.100")');
      print('   2. For iPhone hotspot: ApiConfigManager.setIP("172.20.10.1")');
      print('   3. For Android hotspot: ApiConfigManager.setIP("192.168.43.1")');
      print('   4. For auto-detection: ApiConfigManager.resetToAuto()');
    }
    print('5. Check config: ApiConfigManager.showConfig()');
  }
  
  /// Update the settings file with a new IP
  static void updateSettingsFile(String newIP) {
    print('📝 To permanently change your IP address:');
    print('   1. Open: lib/config/api_settings.dart');
    print('   2. Change line: static const String serverIP = \'$newIP\';');
    print('   3. Save the file and restart your app');
    
    if (kIsWeb) {
      print('\n🌐 Web platform notes:');
      print('   - Make sure your server is accessible from web browsers');
      print('   - Check CORS (Cross-Origin Resource Sharing) settings');
      print('   - Consider using HTTPS for production web apps');
    }
  }
}
