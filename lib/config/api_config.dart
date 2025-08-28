class ApiConfig {
  // 🚀 CHANGE THIS BASE URL WHEN YOUR SERVER IP CHANGES
  static const String baseUrl = 'http://192.168.1.102:5000';
  
  // API endpoints
  static const String authLogin = '/api/auth/login';
  static const String authRegister = '/api/auth/register';
  static const String trekData = '/api/data/';
  
  // Helper method to get full URL for auth endpoints
  static String getAuthUrl(String endpoint) => '$baseUrl$endpoint';
  
  // Helper method to get full URL for trek endpoints
  static String getTrekUrl(String endpoint) => '$baseUrl$trekData$endpoint';
  
  // Timeout configurations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
