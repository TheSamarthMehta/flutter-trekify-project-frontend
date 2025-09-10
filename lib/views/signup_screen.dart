import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trekify/controllers/auth_controller.dart';
import 'package:trekify/controllers/app_drawer_controller.dart';
import 'package:trekify/widgets/keyboard_dismiss_wrapper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    if (args is Map) {
      final String? email = args['email'] as String?;
      final String? password = args['password'] as String?;
      if (email != null && email.isNotEmpty) {
        _emailController.text = email;
      }
      if (password != null && password.isNotEmpty) {
        _passwordController.text = password;
        _confirmPasswordController.text = password;
      }
      
      // Show a welcome message if coming from login
      if (email != null && email.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar('Welcome', 'Please complete your registration by adding your name');
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      final auth = Get.find<AuthController>();
      final result = await auth.signUp(_nameController.text.trim(), _emailController.text.trim(), _passwordController.text);
      if (result['success'] == true) {
        // Ensure the app drawer controller is set to home screen (index 0)
        final appDrawerController = Get.find<AppDrawerController>();
        appDrawerController.reset(); // This sets selectedIndex to 0 and navigationStack to [0]
        Get.offAllNamed('/');
      } else {
        Get.snackbar('Error', result['message'] ?? 'Please try again');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardDismissWrapper(
        child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A), // Deep blue
              Color(0xFF3B82F6), // Blue
              Color(0xFF059669), // Emerald
              Color(0xFF10B981), // Light emerald
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              
              // Header Section
              Column(
                children: [
                  // App Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.landscape_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Title
                  Text(
                    'Join the Community',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Create your trekking profile',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              
              // Signup Form
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Create Account',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2937),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      
                      // Name Field
                      _buildCleanTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person_outline,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Name is required';
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Email Field
                      _buildCleanTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Email is required';
                          if (!value.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Password Field
                      _buildCleanTextField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock_outline,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey.shade500,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Password is required';
                          if (value.length < 6) return 'Min 6 characters';
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Confirm Password Field
                      _buildCleanTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        icon: Icons.lock_reset_outlined,
                        obscureText: _obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey.shade500,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Confirm your password';
                          if (value != _passwordController.text) return 'Passwords do not match';
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Sign Up Button
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A8A),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1E3A8A).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _handleSignup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Create Account',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Sign In Link
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Get.back(),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF1E3A8A),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ],
          ),
        ),
        ),
        ),
      ),
    );
  }

  Widget _buildCleanTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            validator: validator,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color(0xFF1F2937),
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: label,
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF6B7280),
                size: 20,
              ),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintStyle: GoogleFonts.poppins(
                color: const Color(0xFF9CA3AF),
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}