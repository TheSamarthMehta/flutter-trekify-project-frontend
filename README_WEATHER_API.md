# 🌤️ Weather API Integration Guide

This guide explains how to set up real-time weather data for the Trekify app using OpenWeatherMap API.

## 🚀 Quick Setup

### 1. Get OpenWeatherMap API Key

1. Visit [OpenWeatherMap](https://openweathermap.org/)
2. Sign up for a free account
3. Go to "My API Keys" section
4. Copy your API key

### 2. Configure the API Key

1. Open `lib/config/weather_config.dart`
2. Replace `YOUR_OPENWEATHERMAP_API_KEY` with your actual API key:

```dart
static const String openWeatherMapApiKey = 'your_actual_api_key_here';
```

### 3. Test the Integration

1. Run the app
2. The weather data will automatically update every 5 minutes
3. Check the console for weather API logs

## 📍 Default Location

The app is configured to show weather for **Manali, India** by default (popular trekking destination).

### Change Default Location

Edit `lib/config/weather_config.dart`:

```dart
// Change these coordinates
static const double defaultLatitude = 30.7333;  // Your latitude
static const double defaultLongitude = 77.0667; // Your longitude
```

## 🌍 Popular Trekking Locations

The app includes predefined coordinates for popular trekking destinations in India:

- **Manali** - Himalayan treks
- **Rishikesh** - River rafting & yoga
- **Shimla** - Hill station treks
- **Darjeeling** - Tea garden walks
- **Munnar** - Kerala backwaters
- **Ooty** - Nilgiri hills
- **Coorg** - Coffee plantation trails
- **Ladakh** - High altitude adventures

## ⚙️ Configuration Options

### Weather Update Intervals

```dart
static const int weatherUpdateIntervalMinutes = 5;  // Update every 5 minutes
static const int weatherCacheExpiryMinutes = 10;    // Cache expires in 10 minutes
```

### Units

```dart
static const String units = 'metric';  // Celsius, km/h, km
// Change to 'imperial' for Fahrenheit, mph, miles
```

### Language

```dart
static const String language = 'en';  // English
// Change to 'hi' for Hindi, 'mr' for Marathi, etc.
```

## 🔧 API Endpoints

The service uses these OpenWeatherMap endpoints:

- **Current Weather**: `/weather` - Real-time weather data
- **Forecast**: `/forecast` - 5-day weather forecast (3-hour intervals)

## 📱 Features

### Real-time Weather Data
- Temperature (°C)
- Weather condition (Clear, Cloudy, Rain, etc.)
- Humidity (%)
- Wind speed (km/h)
- Visibility (km)
- Pressure (hPa)
- Feels like temperature
- Sunrise/sunset times

### Automatic Updates
- Weather refreshes every 5 minutes
- Fallback data when API is unavailable
- Error handling with graceful degradation

### Location Support
- GPS coordinates support
- City name support
- Multiple trekking destinations

## 🚨 Troubleshooting

### API Key Issues
```
⚠️ Weather API key not configured. Using fallback data.
```
**Solution**: Check your API key in `weather_config.dart`

### Network Errors
```
❌ Weather API Error: SocketException
```
**Solution**: Check internet connection and API endpoint accessibility

### Rate Limiting
```
❌ Weather API error: 429 - Too Many Requests
```
**Solution**: Free tier allows 1000 calls/day. Reduce update frequency if needed.

### Invalid Location
```
❌ Weather API error: 404 - Not Found
```
**Solution**: Check coordinates or city name spelling

## 💡 Advanced Usage

### Custom Weather Updates

```dart
// In your controller
final weatherService = WeatherService();

// Get weather for specific coordinates
final weather = await weatherService.getCurrentWeather(
  lat: 28.6139,  // Delhi
  lon: 77.2090,
);

// Get weather for city name
final weather = await weatherService.getCurrentWeather(
  cityName: 'Mumbai',
);

// Get 5-day forecast
final forecast = await weatherService.getWeatherForecast(
  cityName: 'Bangalore',
);
```

### Weather Icons

The service provides weather icon URLs:

```dart
final iconUrl = weatherService.getWeatherIconUrl('01d'); // Clear sky icon
```

## 🔒 Security Notes

- **Never commit your API key** to version control
- Use environment variables for production
- Consider API key rotation for security
- Monitor API usage to avoid rate limiting

## 📊 API Limits

- **Free Tier**: 1000 calls/day
- **Paid Plans**: Starting from $40/month for higher limits
- **Update Frequency**: Recommended every 5-10 minutes

## 🌟 Benefits

1. **Real-time Data**: Live weather updates for trekking safety
2. **Location Accuracy**: Precise coordinates for trekking destinations
3. **Fallback Support**: App works even when API is unavailable
4. **Performance**: Efficient caching and update intervals
5. **User Experience**: Dynamic weather information enhances trek planning

## 📞 Support

For OpenWeatherMap API issues:
- [API Documentation](https://openweathermap.org/api)
- [Support Forum](https://openweathermap.org/support)
- [Status Page](https://openweathermap.org/status)

For Trekify app issues:
- Check the console logs for detailed error messages
- Verify API key configuration
- Test with different locations
