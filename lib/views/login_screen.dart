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
        Get.offAllNamed('/signup', arguments: {
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        });
      } else {
        Get.snackbar('Login failed', result['message'] ?? 'Please try again');
      }
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
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_outline),
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
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('or'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    // Placeholder for Google sign-in integration
                  },
                  icon: Image.asset('assets/images/google_signin_light.png', height: 20),
                  label: const Text('Continue with Google'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}