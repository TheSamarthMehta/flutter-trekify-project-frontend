import 'dart:convert';
import 'package:get/get.dart';
import 'package:trekify/services/auth_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trekify/controllers/wishlist_controller.dart';
import 'package:trekify/controllers/iternary_controllers.dart';
import 'package:trekify/controllers/states_controller.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var user = Rxn<Map<String, dynamic>>();
  final AuthService _authService = AuthService();
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Check session validity and try auto-login
    checkSessionAndAutoLogin();
  }

  /// ✅ NEW: Check session validity and auto-login
  /// This will automatically log out users after 3 days of inactivity
  Future<void> checkSessionAndAutoLogin() async {
    final token = _storage.read('auth_token');
    final storedUser = _storage.read('auth_user');
    final lastLoginTime = _storage.read('last_login_time');
    
    // Check if we have stored credentials
    if (token != null && storedUser is Map) {
      // Check if it's been more than 3 days since last login
      if (lastLoginTime != null) {
        final lastLogin = DateTime.parse(lastLoginTime);
        final now = DateTime.now();
        final difference = now.difference(lastLogin);
        
        print('🕐 Last login: $lastLogin');
        print('🕐 Current time: $now');
        print('🕐 Days since last login: ${difference.inDays}');
        
        // If more than 3 days have passed, clear session and force logout
        if (difference.inDays >= 3) {
          print('⏰ Session expired (${difference.inDays} days). Clearing session...');
          _clearSession();
          isLoggedIn.value = false;
          return;
        }
      }
      
      // Session is valid, proceed with auto-login
      user.value = {
        ...Map<String, dynamic>.from(storedUser),
        'token': token,
      };
      isLoggedIn.value = true;
      
      // Update last login time
      _storage.write('last_login_time', DateTime.now().toIso8601String());
      
      // Load user's data after successful auto-login
      final userId = user.value?['id']?.toString() ?? 
                    user.value?['_id']?.toString() ?? 
                    user.value?['email']?.toString();
      if (userId != null) {
        print('🔐 Loading user data for: $userId');
        final wishlistController = Get.find<WishlistController>();
        final itineraryController = Get.find<ItineraryController>();
        final statesController = Get.find<StatesController>();
        
        wishlistController.loadWishlistForUser(userId);
        itineraryController.loadItineraryForUser(userId);
        statesController.loadExploredTreksForUser(userId);
        
        // Debug: Print current state
        printCurrentState();
      }
    } else {
      isLoggedIn.value = false;
    }
  }
  
  /// ✅ NEW: Clear all session data
  void _clearSession() {
    _storage.remove('auth_token');
    _storage.remove('auth_user');
    _storage.remove('last_login_time');
    
    // Clear all user data
    final wishlistController = Get.find<WishlistController>();
    final itineraryController = Get.find<ItineraryController>();
    final statesController = Get.find<StatesController>();
    
    wishlistController.clearData();
    itineraryController.clearData();
    statesController.clearData();
    
    print('🧹 Session cleared successfully');
  }

  void signOut() {
    isLoggedIn.value = false;
    user.value = null;
    _clearSession(); // Use the new session clearing method
    
    Get.offAllNamed('/login');
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final result = await _authService.login(email: email, password: password);
    if (result['success'] == true) {
      // The response structure is: {success: true, message: "...", data: {token: "...", user: {...}}}
      final responseData = result['data'] as Map<String, dynamic>;
      print('🔍 Full login response data: $responseData');
      print('🔍 Response data type: ${responseData.runtimeType}');
      print('🔍 Response data keys: ${responseData.keys.toList()}');
      
      // Extract the nested data containing token and user
      final nestedData = responseData['data'] as Map<String, dynamic>;
      print('🔍 Nested data: $nestedData');
      print('🔍 Nested data keys: ${nestedData.keys.toList()}');
      print('🔍 User field type: ${nestedData['user']?.runtimeType}');
      print('🔍 User field value: ${nestedData['user']}');
      
      isLoggedIn.value = true;
      
      // Extract user data from the correct nested location
      Map<String, dynamic>? backendUser;
      if (nestedData['user'] is Map<String, dynamic>) {
        backendUser = nestedData['user'] as Map<String, dynamic>;
        print('✅ User extracted as Map<String, dynamic>');
      } else if (nestedData['user'] is Map) {
        backendUser = Map<String, dynamic>.from(nestedData['user'] as Map);
        print('✅ User extracted as Map and converted');
      } else {
        print('❌ User field is not a Map: ${nestedData['user']?.runtimeType}');
      }
      
      print('🔍 Backend user data: $backendUser');
      
      // Build user object
      Map<String, dynamic> userData = {};
      
      if (backendUser != null) {
        userData.addAll(backendUser);
        print('✅ Added backend user data');
      }
      
      if (nestedData['token'] != null) {
        userData['token'] = nestedData['token'];
        print('✅ Added token to user data');
      }
      
      user.value = userData;
      print('🔍 Final user.value: ${user.value}');
      
      if (nestedData['token'] != null) _storage.write('auth_token', nestedData['token']);
      if (user.value != null && user.value!.isNotEmpty) _storage.write('auth_user', user.value);
      // Store login timestamp for session management
      _storage.write('last_login_time', DateTime.now().toIso8601String());
      
      // Load user's data after successful login
      final userId = user.value?['id']?.toString() ?? 
                    user.value?['_id']?.toString() ?? 
                    user.value?['email']?.toString();
      print('🔐 User logged in with ID: $userId');
      print('🔍 Available user fields: ${user.value?.keys.toList()}');
      if (userId != null) {
        final wishlistController = Get.find<WishlistController>();
        final itineraryController = Get.find<ItineraryController>();
        final statesController = Get.find<StatesController>();
        
        wishlistController.loadWishlistForUser(userId);
        itineraryController.loadItineraryForUser(userId);
        statesController.loadExploredTreksForUser(userId);
        
        // Initialize states with trek data when all controllers are ready
        try {
          await statesController.initializeStatesWithTreks();
        } catch (e) {
          print('⚠️ Could not initialize states with treks: $e');
        }
        
        // Debug: Print current state
        printCurrentState();
        checkAllControllersStatus();
      } else {
        print('⚠️ No user ID found for data loading');
      }
      
      return {'success': true};
    }
    return {'success': false, 'code': result['code'], 'message': result['message']};
  }

  Future<Map<String, dynamic>> signUp(String name, String email, String password) async {
    final result = await _authService.register(name: name, email: email, password: password);
    if (result['success'] == true) {
      // The response structure is: {success: true, message: "...", data: {token: "...", user: {...}}}
      final responseData = result['data'] as Map<String, dynamic>;
      
      // Extract the nested data containing token and user
      final nestedData = responseData['data'] as Map<String, dynamic>;
      
      isLoggedIn.value = true;
      
      // Extract user data from the correct nested location
      Map<String, dynamic>? backendUser;
      if (nestedData['user'] is Map<String, dynamic>) {
        backendUser = nestedData['user'] as Map<String, dynamic>;
      } else if (nestedData['user'] is Map) {
        backendUser = Map<String, dynamic>.from(nestedData['user'] as Map);
      }
      
      // Build user object
      Map<String, dynamic> userData = {};
      
      if (backendUser != null) {
        userData.addAll(backendUser);
      }
      
      if (nestedData['token'] != null) {
        userData['token'] = nestedData['token'];
      }
      
      user.value = userData;
      if (nestedData['token'] != null) _storage.write('auth_token', nestedData['token']);
      if (user.value != null && user.value!.isNotEmpty) _storage.write('auth_user', user.value);
      // Store login timestamp for session management
      _storage.write('last_login_time', DateTime.now().toIso8601String());
      
      // Initialize empty data for new user
      final userId = user.value?['id']?.toString() ?? 
                    user.value?['_id']?.toString() ?? 
                    user.value?['email']?.toString();
      if (userId != null) {
        final wishlistController = Get.find<WishlistController>();
        final itineraryController = Get.find<ItineraryController>();
        final statesController = Get.find<StatesController>();
        
        wishlistController.loadWishlistForUser(userId);
        itineraryController.loadItineraryForUser(userId);
        statesController.loadExploredTreksForUser(userId);
        
        // Debug: Print current state
        printCurrentState();
      }
      
      return {'success': true};
    }
    return {'success': false, 'code': result['code'], 'message': result['message']};
  }

  void updateUserProfile(String name) {
    if (user.value != null) {
      user.value = {
        ...user.value!,
        'name': name,
      };
      // Save updated user data to storage
      _storage.write('auth_user', user.value);
    }
  }

  // Helper method to get current user info
  String getCurrentUserName() {
    return user.value?['name'] ?? 'Guest User';
  }

  String getCurrentUserEmail() {
    return user.value?['email'] ?? 'No Email';
  }

  bool get isUserLoggedIn => isLoggedIn.value;

  // Debug method to print current state
  void printCurrentState() {
    print('🔍 Auth Controller State:');
    print('  - Is Logged In: ${isLoggedIn.value}');
    print('  - User: ${user.value}');
    print('  - User Name: ${getCurrentUserName()}');
    print('  - User Email: ${getCurrentUserEmail()}');
  }

  // Debug method to check all controllers status
  void checkAllControllersStatus() {
    try {
      final wishlistController = Get.find<WishlistController>();
      final itineraryController = Get.find<ItineraryController>();
      final statesController = Get.find<StatesController>();
      
      print('🔍 All Controllers Status:');
      print('  - WishlistController: ✅ Found');
      print('  - ItineraryController: ✅ Found');
      print('  - StatesController: ✅ Found');
      
      final userId = user.value?['id']?.toString() ?? 
                    user.value?['_id']?.toString() ?? 
                    user.value?['email']?.toString();
      if (userId != null) {
        print('  - Current User ID: $userId');
        print('  - Wishlist Items: ${wishlistController.wishlistItems.length}');
        print('  - Itinerary Items: ${itineraryController.itineraryTreks.length}');
        print('  - Explored Treks: ${statesController.exploredTreks.length}');
      }
    } catch (e) {
      print('❌ Error checking controllers: $e');
    }
  }
  
  /// ✅ NEW: Get session info for debugging
  Map<String, dynamic> getSessionInfo() {
    final token = _storage.read('auth_token');
    final storedUser = _storage.read('auth_user');
    final lastLoginTime = _storage.read('last_login_time');
    
    Map<String, dynamic> info = {
      'hasToken': token != null,
      'hasStoredUser': storedUser != null,
      'hasLastLoginTime': lastLoginTime != null,
    };
    
    if (lastLoginTime != null) {
      try {
        final lastLogin = DateTime.parse(lastLoginTime);
        final now = DateTime.now();
        final difference = now.difference(lastLogin);
        info['lastLogin'] = lastLogin.toIso8601String();
        info['daysSinceLastLogin'] = difference.inDays;
        info['sessionExpired'] = difference.inDays >= 3;
      } catch (e) {
        info['lastLoginError'] = e.toString();
      }
    }
    
    return info;
  }
  
  /// ✅ NEW: Force clear session (for testing)
  void forceClearSession() {
    print('🧪 Force clearing session for testing...');
    _clearSession();
    isLoggedIn.value = false;
    user.value = null;
    print('🧪 Session cleared. User will see login screen on next app launch.');
  }

  /// ✅ NEW: Delete user account
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      final token = user.value?['token'];
      if (token == null) {
        return {'success': false, 'message': 'No authentication token found'};
      }

      final result = await _authService.deleteAccount(token: token);
      if (result['success'] == true) {
        // Clear all user data and session
        _clearSession();
        isLoggedIn.value = false;
        user.value = null;
        
        return {'success': true, 'message': result['message'] ?? 'Account deleted successfully'};
      }
      return {'success': false, 'message': result['message'] ?? 'Failed to delete account'};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred while deleting account'};
    }
  }
}
