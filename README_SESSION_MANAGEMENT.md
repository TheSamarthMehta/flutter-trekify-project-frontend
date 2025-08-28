# Session Management in Trekify

## Overview
Trekify now includes automatic session management that ensures users are logged out after periods of inactivity, providing better security and user experience.

## Features

### 🔐 Automatic Session Expiry
- **3-Day Inactivity Rule**: Users are automatically logged out after 3 days of app inactivity
- **App Reinstall Protection**: When users uninstall and reinstall the app, they must log in again
- **Session Persistence**: Active users (within 3 days) will be automatically logged in

### 🕐 Session Tracking
- **Login Timestamp**: Every login stores a timestamp for session validation
- **Automatic Validation**: App checks session validity on startup
- **Graceful Logout**: Expired sessions are cleared automatically

## How It Works

### 1. App Startup Process
```
App Launch → Check Session → Valid? → Auto Login : Show Login Screen
```

### 2. Session Validation
- Checks stored authentication token
- Validates last login timestamp
- Calculates days since last activity
- Clears session if > 3 days inactive

### 3. Login Process
- Stores authentication token
- Records login timestamp
- Loads user-specific data (wishlist, itinerary, progress)

### 4. Logout Process
- Clears all session data
- Removes stored credentials
- Clears user-specific data
- Redirects to login screen

## Testing Features

### 🧪 Manual Session Clear
- **Profile Screen**: "Clear Session (Test)" option
- **Purpose**: Test auto-logout functionality
- **Usage**: Clears session data immediately

### 📊 Session Information
- **Debug Info**: Available in AuthController
- **Session Status**: Check session validity
- **Last Login**: View session timestamps

## Code Implementation

### Key Methods
```dart
// Check session and auto-login
checkSessionAndAutoLogin()

// Clear all session data
_clearSession()

// Force clear session (for testing)
forceClearSession()

// Get session information
getSessionInfo()
```

### Storage Keys
- `auth_token`: User authentication token
- `auth_user`: User profile data
- `last_login_time`: Session timestamp

## User Experience

### ✅ Benefits
- **Security**: Automatic logout prevents unauthorized access
- **Fresh Start**: Reinstalled apps require new login
- **Data Protection**: User data is cleared on logout
- **Seamless Experience**: Active users stay logged in

### 🔄 User Flow
1. **First Time**: User sees login/signup screen
2. **Active User**: Automatic login to main app
3. **Inactive User**: Session expired, login required
4. **Reinstall**: Fresh start, login required

## Configuration

### Session Duration
Currently set to **3 days** of inactivity. This can be modified in:
```dart
// In AuthController.checkSessionAndAutoLogin()
if (difference.inDays >= 3) {
  // Session expired
}
```

### Storage Management
All session data is stored using `GetStorage` and automatically cleared on:
- Manual logout
- Session expiry
- App uninstall (system behavior)

## Debug Information

### Console Logs
The app provides detailed logging for session management:
```
🕐 Last login: 2024-01-15 10:30:00
🕐 Current time: 2024-01-18 10:30:00
🕐 Days since last login: 3
⏰ Session expired (3 days). Clearing session...
🧹 Session cleared successfully
```

### Session Info
Use `authController.getSessionInfo()` to get current session status:
```dart
{
  'hasToken': true,
  'hasStoredUser': true,
  'hasLastLoginTime': true,
  'lastLogin': '2024-01-15T10:30:00.000Z',
  'daysSinceLastLogin': 2,
  'sessionExpired': false
}
```

## Testing Scenarios

### 1. Fresh Install
- Install app → Login screen appears

### 2. Active User
- Use app daily → Stays logged in

### 3. Inactive User
- Don't use for 3+ days → Login required

### 4. Manual Clear
- Use "Clear Session" → Login required

### 5. App Reinstall
- Uninstall → Reinstall → Login required

## Security Considerations

- **Token Storage**: Secure local storage
- **Data Clearing**: Complete cleanup on logout
- **Session Validation**: Time-based expiry
- **User Privacy**: Data removed on session clear

This session management system ensures that users have a secure and seamless experience while maintaining data privacy and security standards.
