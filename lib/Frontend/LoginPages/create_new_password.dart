import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/LoginPages/app_text_styles.dart';
import 'package:hirebridge/Frontend/LoginPages/reusable_widgets.dart';
import 'package:hirebridge/auth/auth_service.dart';

class CreateNewPasswordPage extends StatefulWidget {
  const CreateNewPasswordPage({Key? key}) : super(key: key);

  @override
  State<CreateNewPasswordPage> createState() => _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  void _handleUpdatePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _authService.updatePassword(newPasswordController.text.trim());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password changed successfully!'),
              backgroundColor: AppColors.greenSuccess,
            ),
          );
          // Navigate back to login
          Navigator.popUntil(context, (route) => route.isFirst);
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
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back, title, close - using appBarTitle style
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.chevron_left,
                      color: AppColors.blue,
                      size: 28,
                    ),
                  ),
                  Text(
                    'Create New Password',
                    style: AppTextStyles.appBarTitle,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      'assets/images/Multiply.png',
                      width: 20,
                      height: 20,
                      color: AppColors.blue,
                    ),
                  ),
                ],
              ),
            ),
            
            // Main content area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 200),
                      
                      // Main Title - using mainTitle style
                      Text(
                        'Create Your New Password',
                        style: AppTextStyles.subheading.copyWith(
                          color: AppColors.blue,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Enter New Password label - using subheading style
                      Text(
                        'Enter New Password',
                        style: AppTextStyles.verySmallHeading.copyWith(
                          color: AppColors.blue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // New Password TextField
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: TextFormField(
                          controller: newPasswordController,
                          obscureText: _obscureNewPassword,
                          style: TextStyle(color: AppColors.cream),
                          decoration: InputDecoration(
                            hintText: '',
                            hintStyle: TextStyle(color: AppColors.cream.withOpacity(0.5)),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureNewPassword = !_obscureNewPassword;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                                  color: AppColors.cream,
                                  size: 20,
                                ),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Confirm Password label - using subheading style
                      Text(
                        'Confirm Password',
                        style: AppTextStyles.verySmallHeading.copyWith(
                          color: AppColors.blue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Confirm Password TextField
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: TextFormField(
                          controller: confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          style: TextStyle(color: AppColors.cream),
                          decoration: InputDecoration(
                            hintText: '',
                            hintStyle: TextStyle(color: AppColors.cream.withOpacity(0.5)),
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
                                  color: AppColors.cream,
                                  size: 20,
                                ),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Continue Button - using CustomButton
                      _isLoading
                          ? const Center(child: CircularProgressIndicator(color: AppColors.blue))
                          : CustomButton(
                              text: 'Continue',
                              backgroundColor: AppColors.blue,
                              textColor: AppColors.cream,
                              onPressed: _handleUpdatePassword,
                            ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom illustration - trees and building
            Container(
              height: 80,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/trees.png',
                    height: 60,
                    color: AppColors.blue,
                  ),
                  Image.asset(
                    'assets/images/building.png',
                    height: 80,
                    color: AppColors.blue,
                  ),
                  Image.asset(
                    'assets/images/building.png',
                    height: 80,
                    color: AppColors.blue,
                  ),
                  Image.asset(
                    'assets/images/trees.png',
                    height: 60,
                    color: AppColors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
