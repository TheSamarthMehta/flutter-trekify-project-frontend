import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/weather_config.dart';

class WeatherService {
  /// Get current weather for a specific location
  Future<Map<String, dynamic>> getCurrentWeather({
    double? lat,
    double? lon,
    String? cityName,
  }) async {
    try {
      if (!WeatherConfig.isApiKeyConfigured) {
        print('⚠️ Weather API key not configured. Using fallback data.');
        return _getFallbackWeatherData();
      }

      final url = WeatherConfig.getWeatherUrl(
        lat: lat,
        lon: lon,
        cityName: cityName,
      );

      print('🌤️ Fetching weather from: $url');

      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final weatherData = _parseWeatherData(data);
        print('✅ Weather data fetched successfully: ${weatherData['temperature']}');
        return weatherData;
      } else {
        print('❌ Weather API error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Weather API Error: $e');
      // Return fallback data if API fails
      return _getFallbackWeatherData();
    }
  }

  /// Get weather forecast for a specific location
  Future<List<Map<String, dynamic>>> getWeatherForecast({
    double? lat,
    double? lon,
    String? cityName,
  }) async {
    try {
      if (!WeatherConfig.isApiKeyConfigured) {
        print('⚠️ Weather API key not configured. Cannot fetch forecast.');
        return [];
      }

      final url = WeatherConfig.getForecastUrl(
        lat: lat,
        lon: lon,
        cityName: cityName,
      );

      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseForecastData(data);
      } else {
        print('❌ Forecast API error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Forecast API Error: $e');
      return [];
    }
  }

  /// Parse weather data from API response
  Map<String, dynamic> _parseWeatherData(Map<String, dynamic> data) {
    final main = data['main'] ?? {};
    final weather = (data['weather'] as List?)?.first ?? {};
    final wind = data['wind'] ?? {};
    final visibility = data['visibility'] ?? 10000; // Default 10km
    final sys = data['sys'] ?? {};
    final coord = data['coord'] ?? {};

    return {
      'temperature': '${main['temp']?.round() ?? 20}°C',
      'condition': weather['main'] ?? 'Clear',
      'description': weather['description'] ?? 'Clear sky',
      'humidity': main['humidity'] ?? 65,
      'windSpeed': wind['speed'] ?? 5,
      'visibility': (visibility / 1000).round(), // Convert to km
      'pressure': main['pressure'] ?? 1013,
      'feelsLike': '${main['feels_like']?.round() ?? 20}°C',
      'location': data['name'] ?? WeatherConfig.defaultLocationName,
      'country': sys['country'] ?? 'IN',
      'iconCode': weather['icon'] ?? '01d',
      'latitude': coord['lat'] ?? WeatherConfig.defaultLatitude,
      'longitude': coord['lon'] ?? WeatherConfig.defaultLongitude,
      'sunrise': sys['sunrise'],
      'sunset': sys['sunset'],
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  /// Parse forecast data from API response
  List<Map<String, dynamic>> _parseForecastData(Map<String, dynamic> data) {
    final list = data['list'] as List? ?? [];
    final List<Map<String, dynamic>> forecast = [];

    for (var item in list) {
      final main = item['main'] ?? {};
      final weather = (item['weather'] as List?)?.first ?? {};
      final wind = item['wind'] ?? {};
      final dt = item['dt'] ?? 0;

      forecast.add({
        'datetime': DateTime.fromMillisecondsSinceEpoch(dt * 1000),
        'temperature': '${main['temp']?.round() ?? 20}°C',
        'condition': weather['main'] ?? 'Clear',
        'description': weather['description'] ?? 'Clear sky',
        'humidity': main['humidity'] ?? 65,
        'windSpeed': wind['speed'] ?? 5,
        'iconCode': weather['icon'] ?? '01d',
      });
    }

    return forecast;
  }

  /// Get fallback weather data when API fails
  Map<String, dynamic> _getFallbackWeatherData() {
    return {
      'temperature': '22°C',
      'condition': 'Clear',
      'description': 'Clear sky',
      'humidity': 65,
      'windSpeed': 12,
      'visibility': 8,
      'pressure': 1013,
      'feelsLike': '24°C',
      'location': WeatherConfig.defaultLocationName,
      'country': 'IN',
      'iconCode': '01d',
      'latitude': WeatherConfig.defaultLatitude,
      'longitude': WeatherConfig.defaultLongitude,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  /// Get weather icon based on condition
  String getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return '01d';
      case 'clouds':
        return '02d';
      case 'rain':
        return '09d';
      case 'drizzle':
        return '09d';
      case 'thunderstorm':
        return '11d';
      case 'snow':
        return '13d';
      case 'mist':
      case 'fog':
        return '50d';
      default:
        return '01d';
    }
  }

  /// Get weather icon URL
  String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  /// Get popular trekking locations
  Map<String, Map<String, double>> getTrekkingLocations() {
    return WeatherConfig.trekkingLocations;
  }

  /// Check if weather data is fresh (within cache expiry time)
  bool isWeatherDataFresh(int timestamp) {
    final dataTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(dataTime).inMinutes;
    return difference < WeatherConfig.weatherCacheExpiryMinutes;
  }
}
