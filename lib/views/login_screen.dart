import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trekify/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      final auth = Get.find<AuthController>();
      final result = await auth.signIn(_emailController.text.trim(), _passwordController.text);
      
      if (result['success'] == true) {
        Get.offAllNamed('/');
      } else if (result['code'] == 'needs_signup') {
        // Show confirmation dialog before navigating to signup
        final shouldSignup = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Account Not Found'),
            content: Text('No account found with email "${_emailController.text.trim()}". Would you like to create a new account?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Create Account'),
              ),
            ],
          ),
        );
        
        if (shouldSignup == true) {
          Get.offAllNamed('/signup', arguments: {
            'email': _emailController.text.trim(),
            'password': _passwordController.text,
          });
        }
      } else if (result['code'] == 'invalid_password') {
        Get.snackbar(
          '🔒 Invalid Password', 
          result['message'] ?? 'Please check your password and try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.teal.shade600,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.lock, color: Colors.white),
          shouldIconPulse: true,
          barBlur: 10,
          overlayBlur: 0.5,
          animationDuration: const Duration(milliseconds: 500),
          forwardAnimationCurve: Curves.easeOutBack,
          reverseAnimationCurve: Curves.easeInBack,
        );
      } else {
        Get.snackbar(
          '❌ Login Failed', 
          result['message'] ?? 'Please try again',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.teal.shade600,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.error_outline, color: Colors.white),
          shouldIconPulse: true,
          barBlur: 10,
          overlayBlur: 0.5,
          animationDuration: const Duration(milliseconds: 500),
          forwardAnimationCurve: Curves.easeOutBack,
          reverseAnimationCurve: Curves.easeInBack,
        );
      }
    } catch (e) {
      Get.snackbar(
        '⚠️ Error', 
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.teal.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        shouldIconPulse: true,
        barBlur: 10,
        overlayBlur: 0.5,
        animationDuration: const Duration(milliseconds: 500),
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeInBack,
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/logo.jpg', height: 96, fit: BoxFit.contain),
                const SizedBox(height: 16),
                Text(
                  'Welcome back to Trekify',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover and plan your next trek',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Email is required';
                              if (!value.contains('@')) return 'Enter a valid email';
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_outline),
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Password is required';
                              if (value.length < 6) return 'Min 6 characters';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _isSubmitting ? null : _handleLogin,
                              child: _isSubmitting
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : const Text('Sign in'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style: theme.textTheme.bodyMedium),
                    TextButton(
                      onPressed: () => Get.toNamed('/signup'),
                      child: const Text('Create account'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}