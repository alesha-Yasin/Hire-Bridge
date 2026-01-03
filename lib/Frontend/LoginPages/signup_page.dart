import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/LoginPages/app_text_styles.dart';
import 'package:hirebridge/Frontend/LoginPages/reusable_widgets.dart';
import 'package:hirebridge/Frontend/LoginPages/login_page.dart';
import 'package:hirebridge/auth/auth_service.dart';
import 'package:hirebridge/models/auth_models.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _authService.signUp(
          SignUpRequest(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            phone: phoneController.text.trim(),
          ),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sign up successful! Please check your email for verification.'),
              backgroundColor: AppColors.greenSuccess,
            ),
          );
          // TODO: Navigate to your home page after signup
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Decore(
      title: 'Sign Up',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Main Title - Sign Up
              Text(
                'Sign  Up',
                style: AppTextStyles.mainTitle,
              ),
              const SizedBox(height: 20),
              
              // Social Login Buttons Row
              Row(
                children: [
                  Expanded(
                    child: SocialLoginButton(
                      text: 'Google',
                      icon: Image.asset(
                        'assets/images/google.png',
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () {
                        // Handle Google login
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SocialLoginButton(
                      text: 'Facebook',
                      icon: Image.asset(
                        'assets/images/facebook.png',
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () {
                        // Handle Facebook login
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Email Address label
              Text(
                'Email Address',
                style: AppTextStyles.verySmallHeading.copyWith(
                  color: AppColors.cream,
                ),
              ),
              const SizedBox(height: 8),
              
              // Email TextField
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: AppColors.blue),
                  decoration: InputDecoration(
                    hintText: '',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // Phone label
              Text(
                'Phone',
                style: AppTextStyles.verySmallHeading.copyWith(
                  color: AppColors.cream,
                ),
              ),
              const SizedBox(height: 8),
              
              // Phone TextField
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: AppColors.blue),
                  decoration: InputDecoration(
                    hintText: '',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // Password label
              Text(
                'Password',
                style: AppTextStyles.verySmallHeading.copyWith(
                  color: AppColors.cream,
                ),
              ),
              const SizedBox(height: 8),
              
              // Password TextField
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  style: TextStyle(color: AppColors.blue),
                  decoration: InputDecoration(
                    hintText: '',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.blue,
                          size: 20,
                        ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // Confirm Password label
              Text(
                'Confirm Password',
                style: AppTextStyles.verySmallHeading.copyWith(
                  color: AppColors.cream,
                ),
              ),
              const SizedBox(height: 8),
              
              // Confirm Password TextField
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  style: TextStyle(color: AppColors.blue),
                  decoration: InputDecoration(
                    hintText: '',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.blue,
                          size: 20,
                        ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 30),
              
              // Continue Button
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.cream))
                  : CustomButton(
                      text: 'Continue',
                      onPressed: _handleSignUp,
                    ),
              const SizedBox(height: 20),
              
              // Already Have an Account? LOG IN
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already Have an Account? ',
                      style: AppTextStyles.verySmallText.copyWith(
                        color: AppColors.cream,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        'LOG IN',
                        style: AppTextStyles.verySmallHeading.copyWith(
                          color: AppColors.cream,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
