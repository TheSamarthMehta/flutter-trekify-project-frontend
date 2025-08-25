// lib/controllers/auth_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:trekify/controllers/app_drawer_controller.dart';
import 'package:trekify/models/user_model.dart';
import 'package:trekify/services/auth_service.dart';
import 'package:trekify/controllers/wishlist_controller.dart';
import 'package:trekify/controllers/states_controller.dart';
import 'iternary_controllers.dart';
import 'dart:developer' as developer;

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final _box = GetStorage();
  final _userTokenKey = 'userToken';

  var isLoading = false.obs;
  var isAuthenticated = false.obs;
  var user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> tryAutoLogin() async {
    final token = _box.read(_userTokenKey);
    if (token == null) {
      Get.offAllNamed('/login');
      return;
    }
    try {
      final response = await http.get(
        Uri.parse('${_authService.baseUrl}/api/auth/me'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );
      if (response.statusCode == 200) {
        user.value = UserModel.fromJson(json.decode(response.body));
        isAuthenticated.value = true;
        await _fetchAllDataForUser(user.value!.id);
        Get.offAllNamed('/');
      } else {
        await signOut();
      }
    } catch (e) {
      await signOut();
    }
  }

  Future<void> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Input Error', 'Please enter both email and password.');
      return;
    }
    isLoading.value = true;

    final result = await _authService.signIn(email, password);
    final statusCode = result['statusCode'];
    final body = result['body'];

    if (statusCode == 200) {
      await _box.write(_userTokenKey, body['token']);
      await tryAutoLogin();
    } else if (statusCode == 404) {
      Get.snackbar('Account Not Found', 'Please create an account to continue.');
      Get.toNamed('/signup', arguments: email);
    } else {
      final errorMessage = body['msg'] ?? 'An unknown error occurred. Status: $statusCode';
      developer.log('Login failed. Status: $statusCode, Body: $body', name: 'AuthController');
      Get.snackbar('Login Failed', errorMessage);
    }

    isLoading.value = false;
  }

  Future<void> signUp(String name, String email, String password) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar('Input Error', 'Please fill all fields.');
      return;
    }
    isLoading.value = true;

    final result = await _authService.signUp(name, email, password);
    final statusCode = result['statusCode'];
    final body = result['body'];

    if (statusCode == 200) {
      // ✅ MODIFIED: Instead of going to login, immediately sign the new user in.
      Get.snackbar(
        'Success!',
        'Your account has been created. Logging you in...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.teal,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
      // This will handle token storage and navigation to the home screen.
      await signIn(email, password);
    } else {
      Get.snackbar('Sign-Up Failed', body['msg'] ?? 'An unknown error occurred.');
    }

    isLoading.value = false;
  }

  Future<void> _fetchAllDataForUser(String userId) async {
    Get.find<WishlistController>().loadWishlistForUser(userId);
    Get.find<ItineraryController>().loadItineraryForUser(userId);
    Get.find<StatesController>().loadExploredTreksForUser(userId);
  }

  void _clearAllUserData() {
    Get.find<WishlistController>().clearData();
    Get.find<ItineraryController>().clearData();
    Get.find<StatesController>().clearData();
  }

  Future<void> signOut() async {
    if (Get.isRegistered<AppDrawerController>()) {
      Get.find<AppDrawerController>().reset();
    }
    _clearAllUserData();
    await _box.remove(_userTokenKey);
    isAuthenticated.value = false;
    user.value = null;
    Get.offAllNamed('/login');
  }

  Future<void> updateUserProfile(String name) async {
    isLoading.value = true;
    try {
      final token = _box.read(_userTokenKey);
      final response = await http.put(
        Uri.parse('${_authService.baseUrl}/api/auth/update'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: json.encode({'name': name}),
      );

      if (response.statusCode == 200) {
        user.value = UserModel.fromJson(json.decode(response.body));
        Get.back();
        Get.snackbar('Success', 'Profile updated successfully.');
      } else {
        Get.snackbar('Error', 'Failed to update profile.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not connect to the server.');
    }
    isLoading.value = false;
  }
}