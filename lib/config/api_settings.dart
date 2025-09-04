/// Simple API Settings - Edit this file to change your server IP
/// 
/// This file contains easy-to-edit settings for your API configuration.
/// You can modify these values without touching the main API config logic.
class ApiSettings {
  // 🚀 QUICK TOGGLE - Change this to switch between production and development
  /// Set to true for production (live backend), false for development (local server)
  /// ✅ PRODUCTION MODE - Using live backend at https://flutter-trekify-project-backend.onrender.com
  static const bool isProduction = true;
  
  // 🚀 EASY CONFIGURATION - Change these values as needed
  
  /// Your server IP address - change this when your server IP changes
  /// For web apps: Use your server's public IP or domain name
  /// For mobile/desktop: Use your local network IP
  static const String serverIP = '10.70.19.209';
  
  /// Your server port
  static const int serverPort = 5000;
  
  /// Enable automatic IP detection (recommended for mobile/desktop)
  /// Note: Not available on web platforms
  /// ✅ DISABLED FOR PRODUCTION - Using live backend instead
  static const bool enableAutoDetection = false;
  
  /// Enable fallback IPs when auto-detection fails (mobile/desktop only)
  /// Note: Not available on web platforms
  /// ✅ DISABLED FOR PRODUCTION - Using live backend instead
  static const bool enableFallbacks = false;
  
  /// Custom fallback IPs (add your common server IPs here)
  /// Note: Only used on mobile/desktop platforms
  /// ✅ NOT NEEDED FOR PRODUCTION - Using live backend instead
  static const List<String> customFallbackIPs = [
    '192.168.1.100',  // Common home network
    '10.0.0.50',      // Common home network
    '172.20.10.1',    // iPhone hotspot
    '192.168.43.1',   // Android hotspot
  ];
  
  /// Connection timeout in seconds
  static const int connectionTimeoutSeconds = 30;
  
  /// Receive timeout in seconds
  static const int receiveTimeoutSeconds = 30;
  
  // 🎯 ENVIRONMENT SETTINGS
  
  /// Production server URL (when isProduction is true)
  /// ✅ UPDATED - Your live backend URL
  static const String productionUrl = 'https://flutter-trekify-project-backend.onrender.com';
  
  /// Development server URL (when isProduction is false)
  /// For web apps: Make sure this is accessible from browsers
  static String get developmentUrl => 'http://$serverIP:$serverPort';
  
  // 📱 NETWORK SETTINGS (Mobile/Desktop Only)
  
  /// Enable network interface detection (mobile/desktop only)
  /// Note: Not available on web platforms
  /// ✅ DISABLED FOR PRODUCTION - Using live backend instead
  static const bool enableNetworkDetection = false;
  
  /// Skip virtual network interfaces (VMware, VirtualBox, etc.)
  /// Note: Not available on web platforms
  static const bool skipVirtualInterfaces = true;
  
  /// Preferred network interface names (leave empty for auto)
  /// Note: Not available on web platforms
  static const List<String> preferredInterfaces = [
    // 'Wi-Fi',
    // 'Ethernet',
    // 'Local Area Connection',
  ];
  
  // 🔧 ADVANCED SETTINGS
  
  /// Enable connection testing before using IP (mobile/desktop only)
  /// Note: Not available on web platforms
  /// ✅ DISABLED FOR PRODUCTION - Using live backend instead
  static const bool testConnectionBeforeUse = false;
  
  /// Connection test timeout in seconds (mobile/desktop only)
  /// Note: Not available on web platforms
  static const int connectionTestTimeout = 2;
  
  /// Enable debug logging
  static const bool enableDebugLogging = true;
  
  /// Cache detected IP address
  static const bool cacheDetectedIP = true;
  
  /// Cache expiration time in minutes
  static const int cacheExpirationMinutes = 30;
  
  // 🌐 WEB-SPECIFIC SETTINGS
  
  /// Web app configuration notes:
  /// 
  /// ✅ YOUR BACKEND IS NOW LIVE! 🎉
  /// 
  /// 1. Server Accessibility:
  ///    - Your server is now live at: https://flutter-trekify-project-backend.onrender.com
  ///    - ✅ No more local IP configuration needed for web!
  ///    - ✅ HTTPS is already configured for production
  /// 
  /// 2. CORS (Cross-Origin Resource Sharing):
  ///    - Your server must allow requests from web browsers
  ///    - Configure CORS headers on your server
  ///    - Example CORS headers:
  ///      Access-Control-Allow-Origin: *
  ///      Access-Control-Allow-Methods: GET, POST, PUT, DELETE
  ///      Access-Control-Allow-Headers: Content-Type, Authorization
  /// 
  /// 3. Network Configuration:
  ///    - Web apps cannot detect local network IPs
  ///    - Web apps cannot test direct socket connections
  ///    - ✅ Now uses your live backend URL directly
  /// 
  /// 4. For Local Development:
  ///    - Run your server on localhost or 0.0.0.0
  ///    - Use 'localhost' or '127.0.0.1' as serverIP
  ///    - Make sure your server accepts connections from all interfaces
  /// 
  /// 5. Production Benefits:
  ///    - ✅ No more IP address changes needed
  ///    - ✅ Works from anywhere in the world
  ///    - ✅ HTTPS security included
  ///    - ✅ Scalable cloud hosting
  /// 
  /// 6. Mobile/Desktop Production:
  ///    - ✅ Now also uses live backend directly
  ///    - ✅ No more local network detection needed
  ///    - ✅ No more connection timeouts
  ///    - ✅ Works from any network (WiFi, mobile data, etc.)
  /// 
  /// 7. Quick Development Mode:
  ///    - To test with local server: Change `isProduction = false`
  ///    - To use live backend: Change `isProduction = true`
  ///    - Restart app after changing this setting
}
