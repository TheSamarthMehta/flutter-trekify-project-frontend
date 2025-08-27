import 'package:get/get.dart';
import 'package:trekify/services/auth_service.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var user = Rxn<Map<String, dynamic>>();
  final AuthService _authService = AuthService();
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Try auto-login from stored token/user
    tryAutoLogin();
  }

  Future<void> tryAutoLogin() async {
    final token = _storage.read('auth_token');
    final storedUser = _storage.read('auth_user');
    if (token != null && storedUser is Map) {
      user.value = {
        ...storedUser.cast<String, dynamic>(),
        'token': token,
      };
      isLoggedIn.value = true;
    } else {
      isLoggedIn.value = false;
    }
  }

  void signOut() {
    isLoggedIn.value = false;
    user.value = null;
    _storage.remove('auth_token');
    _storage.remove('auth_user');
    Get.offAllNamed('/login');
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final result = await _authService.login(email: email, password: password);
    if (result['success'] == true) {
      final data = result['data'] as Map<String, dynamic>;
      isLoggedIn.value = true;
      final Map<String, dynamic>? backendUser = (data['user'] is Map<String, dynamic>) ? data['user'] as Map<String, dynamic> : null;
      user.value = {
        if (backendUser != null) ...backendUser,
        if (data['token'] != null) 'token': data['token'],
      };
      if (data['token'] != null) _storage.write('auth_token', data['token']);
      if (backendUser != null) _storage.write('auth_user', backendUser);
      return {'success': true};
    }
    return {'success': false, 'code': result['code'], 'message': result['message']};
  }

  Future<Map<String, dynamic>> signUp(String name, String email, String password) async {
    final result = await _authService.register(name: name, email: email, password: password);
    if (result['success'] == true) {
      final data = result['data'] as Map<String, dynamic>;
      isLoggedIn.value = true;
      final Map<String, dynamic>? backendUser = (data['user'] is Map<String, dynamic>) ? data['user'] as Map<String, dynamic> : null;
      user.value = {
        if (backendUser != null) ...backendUser,
        if (data['token'] != null) 'token': data['token'],
      };
      if (data['token'] != null) _storage.write('auth_token', data['token']);
      if (backendUser != null) _storage.write('auth_user', backendUser);
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
    }
  }
}
