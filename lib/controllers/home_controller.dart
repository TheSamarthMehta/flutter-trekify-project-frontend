import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../services/weather_service.dart';

class HomeController extends GetxController {
  var selectedDifficulty = ''.obs;
  var selectedTrekType = ''.obs;
  var selectedSeason = ''.obs;

  // Weather data
  var currentTemperature = '22°C'.obs;
  var weatherCondition = 'Clear Sky'.obs;
  var weatherDescription = 'Clear sky'.obs;
  var location = 'Mountain Peak'.obs;
  var humidity = 65.obs;
  var windSpeed = 12.obs;
  var visibility = 8.obs;
  var pressure = 1013.obs;
  var feelsLike = '24°C'.obs;
  var weatherIcon = Icons.wb_sunny.obs;
  var weatherIconCode = '01d'.obs;
  var isLoadingWeather = false.obs;

  // Trek statistics with animated counters
  var totalTreks = 0.obs;
  var totalDestinations = 0.obs;
  var averageRating = 0.0.obs;
  var targetTotalTreks = 150;
  var targetDestinations = 25;
  var targetRating = 4.8;

  // Featured treks data
  var featuredTreks = <Map<String, dynamic>>[].obs;

  // Weather service
  final WeatherService _weatherService = WeatherService();

  // Timer for weather updates
  Timer? _weatherTimer;
  Timer? _counterTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    _fetchRealWeatherData();
    _startWeatherUpdates();
    _startCounterAnimation();
  }

  @override
  void onClose() {
    _weatherTimer?.cancel();
    _counterTimer?.cancel();
    super.onClose();
  }

  void _initializeData() {
    // Initialize featured treks
    featuredTreks.value = [
      {
        'title': 'Himalayan Peak Trek',
        'location': 'Himalayas, India',
        'difficulty': 'Difficult',
        'rating': '4.9',
        'imageUrl': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843182/difficult_net5vk.jpg',
      },
      {
        'title': 'Valley of Flowers',
        'location': 'Uttarakhand, India',
        'difficulty': 'Moderate',
        'rating': '4.7',
        'imageUrl': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843182/moderate_xu1jby.jpg',
      },
      {
        'title': 'Western Ghats Trail',
        'location': 'Karnataka, India',
        'difficulty': 'Easy',
        'rating': '4.5',
        'imageUrl': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843181/easy_tix09h.jpg',
      },
      {
        'title': 'Kedarkantha Trek',
        'location': 'Uttarakhand, India',
        'difficulty': 'Moderate',
        'rating': '4.6',
        'imageUrl': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843182/moderate_xu1jby.jpg',
      },
      {
        'title': 'Triund Trek',
        'location': 'Himachal Pradesh, India',
        'difficulty': 'Easy',
        'rating': '4.4',
        'imageUrl': 'https://res.cloudinary.com/dvnr3ouix/image/upload/v1754843181/easy_tix09h.jpg',
      },
    ];
  }

  /// Fetch real weather data from API
  Future<void> _fetchRealWeatherData() async {
    try {
      isLoadingWeather.value = true;
      final weatherData = await _weatherService.getCurrentWeather();
      
      // Update weather variables
      currentTemperature.value = weatherData['temperature'] ?? '22°C';
      weatherCondition.value = weatherData['condition'] ?? 'Clear';
      weatherDescription.value = weatherData['description'] ?? 'Clear sky';
      location.value = weatherData['location'] ?? 'Mountain Peak';
      humidity.value = weatherData['humidity'] ?? 65;
      windSpeed.value = weatherData['windSpeed'] ?? 12;
      visibility.value = weatherData['visibility'] ?? 8;
      pressure.value = weatherData['pressure'] ?? 1013;
      feelsLike.value = weatherData['feelsLike'] ?? '24°C';
      weatherIconCode.value = weatherData['iconCode'] ?? '01d';
      
      // Update weather icon
      _updateWeatherIcon(weatherData['condition'] ?? 'Clear');
      
      print('✅ Weather data updated successfully');
    } catch (e) {
      print('❌ Error fetching weather data: $e');
      // Keep fallback data if API fails
    } finally {
      isLoadingWeather.value = false;
    }
  }

  void _startWeatherUpdates() {
    // Update weather every 5 minutes for real-time data
    _weatherTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _fetchRealWeatherData();
    });
  }

  void _startCounterAnimation() {
    // Animate counters on app start
    _counterTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (totalTreks.value < targetTotalTreks) {
        totalTreks.value += 3;
      }
      if (totalDestinations.value < targetDestinations) {
        totalDestinations.value += 1;
      }
      if (averageRating.value < targetRating) {
        averageRating.value += 0.1;
      }

      // Stop timer when all counters reach target
      if (totalTreks.value >= targetTotalTreks &&
          totalDestinations.value >= targetDestinations &&
          averageRating.value >= targetRating) {
        timer.cancel();
      }
    });
  }

  void _updateWeatherData() {
    // Simulate weather changes (fallback when API is not available)
    final random = Random();
    
    // Update temperature (between 15-25°C)
    final newTemp = 15 + random.nextInt(11);
    currentTemperature.value = '${newTemp}°C';

    // Update weather condition
    final conditions = [
      'Partly Cloudy',
      'Sunny',
      'Cloudy',
      'Light Rain',
      'Clear Sky',
      'Misty',
      'Windy',
    ];
    weatherCondition.value = conditions[random.nextInt(conditions.length)];

    // Update weather icon based on condition
    _updateWeatherIcon(weatherCondition.value);

    // Update humidity (between 50-80%)
    humidity.value = 50 + random.nextInt(31);

    // Update wind speed (between 8-20 km/h)
    windSpeed.value = 8 + random.nextInt(13);

    // Update visibility (between 5-15 km)
    visibility.value = 5 + random.nextInt(11);
  }

  void _updateWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        weatherIcon.value = Icons.wb_sunny;
        break;
      case 'cloudy':
      case 'clouds':
        weatherIcon.value = Icons.cloud;
        break;
      case 'partly cloudy':
        weatherIcon.value = Icons.cloud;
        break;
      case 'light rain':
      case 'rain':
        weatherIcon.value = Icons.grain;
        break;
      case 'clear sky':
        weatherIcon.value = Icons.wb_sunny;
        break;
      case 'misty':
      case 'mist':
      case 'fog':
        weatherIcon.value = Icons.cloud;
        break;
      case 'windy':
        weatherIcon.value = Icons.air;
        break;
      default:
        weatherIcon.value = Icons.cloud;
    }
  }

  // Manual weather refresh
  Future<void> refreshWeather() async {
    await _fetchRealWeatherData();
  }

  // Reset counters for animation
  void resetCounters() {
    totalTreks.value = 0;
    totalDestinations.value = 0;
    averageRating.value = 0.0;
    _startCounterAnimation();
  }

  void selectSeason(String season) {
    selectedSeason.value = season;
  }

  void selectDifficulty(String level) {
    selectedDifficulty.value = level;
  }

  void selectTrekType(String type) {
    selectedTrekType.value = type;
  }
}
