import 'package:get/get.dart';
import 'package:trekify/services/auth_service.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var user = Rxn<Map<String, dynamic>>();
  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    // Start logged out by default
  }

  Future<void> tryAutoLogin() async {
    // TODO: load from storage if needed
    isLoggedIn.value = false;
  }

  void signOut() {
    isLoggedIn.value = false;
    user.value = null;
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
