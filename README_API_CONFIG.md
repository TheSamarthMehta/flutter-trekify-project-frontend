# Simple API Configuration

## How to Change the API Base URL

To change your server IP address, simply edit one file:

### 1. Open `lib/config/api_config.dart`

### 2. Change the baseUrl constant:

```dart
class ApiConfig {
  // 🚀 CHANGE THIS BASE URL WHEN YOUR SERVER IP CHANGES
  static const String baseUrl = 'http://10.70.19.209:5000';  // ← Change this line
  
  // ... rest of the file
}
```

### 3. Examples:

```dart
// Change to 192.168.1.100
static const String baseUrl = 'http://192.168.1.100:5000';

// Change to 10.0.0.50
static const String baseUrl = 'http://10.0.0.50:5000';
```

### 4. Restart your app

That's it! All API calls will now use the new IP address.

## Files Using This Configuration

- `lib/services/auth_service.dart` - Login and registration
- `lib/services/trek_service.dart` - Fetching trek data

## API Endpoints

All endpoints are defined in `lib/config/api_config.dart`:

- `/api/auth/login` - User login
- `/api/auth/register` - User registration  
- `/api/data/` - Trek data

## Troubleshooting

If you get connection errors:
1. Make sure your server is running on the new IP
2. Check that port 5000 is open
3. Verify the IP address is correct
4. Restart your Flutter app after changing the IP
