import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/app_text_styles.dart';
import 'package:hirebridge/Frontend/LoginPages/reusable_widgets.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/LoginPages/forget_password.dart';
import 'package:hirebridge/Frontend/LoginPages/signup_page.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Decore(
      title: 'Login',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Main Title - WELCOME BACK!
              Text(
                'WELCOME BACK!',
                style: AppTextStyles.mainTitle,
              ),
              const SizedBox(height: 8),
              
              // Subtitle - HELLO There, Login to continue
              Text(
                'HELLO There, Login to continue',
                style: AppTextStyles.hintText.copyWith(
                  color: AppColors.cream,
                ),
              ),
              const SizedBox(height: 100),
              
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
              const SizedBox(height: 20),
              
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
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 12),
              
              // Forget Password? link
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgetPasswordPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Forget Password?',
                    style: AppTextStyles.verySmallText.copyWith(
                      color: AppColors.cream,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Log In Button
              CustomButton(
                text: 'Log In',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle login
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Login successful!'),
                        backgroundColor: AppColors.greenSuccess,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
              
              // Don't have an account? Sign Up
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyles.verySmallText.copyWith(
                        color: AppColors.cream,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: AppTextStyles.verySmallHeading.copyWith(
                          color: AppColors.cream,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
