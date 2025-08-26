import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoggedIn = true.obs; // Set to true to skip authentication
  var user = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    // Initialize user with dummy data
    user.value = {
      'name': 'Trekker',
      'email': 'user@trekify.com',
    };
  }

  Future<void> tryAutoLogin() async {
    // For now, just set user as logged in
    isLoggedIn.value = true;
    user.value = {
      'name': 'Trekker',
      'email': 'user@trekify.com',
    };
    
    // Navigate to main screen
    Get.offAllNamed('/');
  }

  void signOut() {
    isLoggedIn.value = false;
    user.value = null;
    Get.offAllNamed('/splash');
  }

  Future<void> signIn(String email, String password) async {
    // Mock sign in
    isLoggedIn.value = true;
    user.value = {
      'name': 'Trekker',
      'email': email,
    };
  }

  Future<void> signUp(String name, String email, String password) async {
    // Mock sign up
    isLoggedIn.value = true;
    user.value = {
      'name': name,
      'email': email,
    };
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
