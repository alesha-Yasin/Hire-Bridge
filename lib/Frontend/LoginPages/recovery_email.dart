import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/app_text_styles.dart';
import 'package:hirebridge/Frontend/LoginPages/reusable_widgets.dart';
import 'package:hirebridge/Frontend/LoginPages/otp_verification.dart';
import 'package:hirebridge/auth/auth_service.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
class RecoveryEmailPage extends StatefulWidget {
  const RecoveryEmailPage({Key? key}) : super(key: key);

  @override
  State<RecoveryEmailPage> createState() => _RecoveryEmailPageState();
}

class _RecoveryEmailPageState extends State<RecoveryEmailPage> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _isLoading = false;

  void _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _authService.requestPasswordReset(emailController.text.trim());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Recovery code sent to your email!'),
              backgroundColor: AppColors.greenSuccess,
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationPage(
                verificationType: 'Email',
                email: emailController.text.trim(),
                isForRecovery: true, // Per Step 2: using OtpType.recovery
              ),
            ),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Decore(
      title: 'Password Recovery',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Title
              Text(
                'Recovery from Email',
                style: AppTextStyles.mainTitle.copyWith(
                  
                ),
              ),
              const SizedBox(height: 8),
              
              // Subtitle
              const Text(
                'We will sent password recovery code on this email.',
                style: AppTextStyles.hintText,
              ),
              const SizedBox(height: 40),
              
              // Email Address label
              const Text(
                'Email Address',
                style: AppTextStyles.subheading,
              ),
              const SizedBox(height: 12),
              
              // Email TextField (dark background with check icon)
              CustomTextField(
                controller: emailController,
                hintText: '',
                showCheckIcon: true,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 40),
              
              // Send Link Recovery Button
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.blue))
                  : CustomButton(
                      text: 'Send Link Recovery',
                      onPressed: _handleResetPassword,
                    ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}