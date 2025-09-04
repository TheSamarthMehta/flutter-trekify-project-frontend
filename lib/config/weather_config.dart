class WeatherConfig {
  // OpenWeatherMap API Configuration
  static const String openWeatherMapApiKey = 'd9390340447b4dd4be21f0e973aab7f5';
  
  // Default location coordinates (Manali, India - popular trekking destination)
  static const double defaultLatitude = 30.7333;
  static const double defaultLongitude = 77.0667;
  
  // Weather update intervals
  static const int weatherUpdateIntervalMinutes = 5;
  static const int weatherCacheExpiryMinutes = 10;
  
  // API endpoints
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String weatherEndpoint = '/weather';
  static const String forecastEndpoint = '/forecast';
  
  // Units (metric for Celsius, imperial for Fahrenheit)
  static const String units = 'metric';
  
  // Language for weather descriptions
  static const String language = 'en';
  
  // Popular trekking locations in India
  static const Map<String, Map<String, double>> trekkingLocations = {
    'Manali': {'lat': 30.7333, 'lon': 77.0667},
    'Rishikesh': {'lat': 30.0869, 'lon': 78.2676},
    'Shimla': {'lat': 31.1048, 'lon': 77.1734},
    'Darjeeling': {'lat': 27.0360, 'lon': 88.3957},
    'Munnar': {'lat': 10.0889, 'lon': 77.0595},
    'Ooty': {'lat': 11.4102, 'lon': 76.6950},
    'Coorg': {'lat': 12.3375, 'lon': 75.8069},
    'Ladakh': {'lat': 34.1642, 'lon': 77.5847},
  };
  
  /// Get API URL for current weather
  static String getWeatherUrl({double? lat, double? lon, String? cityName}) {
    if (cityName != null) {
      return '$baseUrl$weatherEndpoint?q=$cityName&appid=$openWeatherMapApiKey&units=$units&lang=$language';
    } else {
      final latitude = lat ?? defaultLatitude;
      final longitude = lon ?? defaultLongitude;
      return '$baseUrl$weatherEndpoint?lat=$latitude&lon=$longitude&appid=$openWeatherMapApiKey&units=$units&lang=$language';
    }
  }
  
  /// Get API URL for weather forecast
  static String getForecastUrl({double? lat, double? lon, String? cityName}) {
    if (cityName != null) {
      return '$baseUrl$forecastEndpoint?q=$cityName&appid=$openWeatherMapApiKey&units=$units&lang=$language';
    } else {
      final latitude = lat ?? defaultLatitude;
      final longitude = lon ?? defaultLongitude;
      return '$baseUrl$forecastEndpoint?lat=$latitude&lon=$longitude&appid=$openWeatherMapApiKey&units=$units&lang=$language';
    }
  }
  
  /// Check if API key is configured
  static bool get isApiKeyConfigured => openWeatherMapApiKey != 'YOUR_OPENWEATHERMAP_API_KEY';
  
  /// Get default location name
  static String get defaultLocationName => 'Manali, India';
}
