import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/LoginPages/app_text_styles.dart';
import 'package:hirebridge/Frontend/LoginPages/reusable_widgets.dart';
import 'package:hirebridge/Frontend/LoginPages/create_new_password.dart';
import 'package:hirebridge/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hirebridge/Frontend/LoginPages/login_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;
  final bool isForRecovery;
  
  final dynamic verificationType;

  const OtpVerificationPage({
    super.key,
    required this.verificationType,
    required this.email,
    this.isForRecovery = false,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<String> otpDigits = List.generate(8, (_) => '');
  int currentIndex = 0;
  final _authService = AuthService();
  bool _isLoading = false;

  void _handleVerifyOTP() async {
    if (isOtpComplete()) {
      setState(() => _isLoading = true);
      try {
        OtpType otpType;
        if (widget.verificationType == 'SMS') {
          otpType = OtpType.sms;
        } else {
          otpType = widget.isForRecovery ? OtpType.recovery : OtpType.email;
        }

        await _authService.verifyOTP(
          token: getOtpCode(),
          email: widget.verificationType == 'Email' ? widget.email : null,
          phone: widget.verificationType == 'SMS' ? widget.email : null,
          type: otpType,
        );
        if (mounted) {
          if (widget.isForRecovery) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateNewPasswordPage(),
              ),
            );
          } else {
            // TODO: Navigate to your home page after verification
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          }
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

  void _onNumberTap(String number) {
    if (currentIndex < 8) {
      setState(() {
        otpDigits[currentIndex] = number;
        currentIndex++;
      });
    }
  }

  void _onDelete() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        otpDigits[currentIndex] = '';
      });
    }
  }

  String getOtpCode() {
    return otpDigits.join();
  }

  bool isOtpComplete() {
    return otpDigits.every((digit) => digit.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back, title, close
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
                    'Phone Verification',
                    style: AppTextStyles.appBarTitle.copyWith(
                      color: AppColors.blue,
                    ),
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
            
            // Building illustration area - shorter
            Expanded(
              flex: 1,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Building and trees illustration
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/images/trees.png',
                          height: 50,
                          color: AppColors.blue,
                        ),
                        Image.asset(
                          'assets/images/building.png',
                          height: 80,
                          color: AppColors.cream,
                        ),
                        Image.asset(
                          'assets/images/trees.png',
                          height: 50,
                          color: AppColors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Content area with dark blue background - more space
            Expanded(
              flex: 8,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      
                      //////////////////////////////////////////  mainTitle - Enter OTP
                      Text(
                        'Enter  OTP',
                        style: AppTextStyles.mainTitle.copyWith(
                          color: AppColors.cream,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Subtitle hint text
                      Text(
                        widget.verificationType == 'SMS'
                            ? 'We have send it on your phone number'
                            : 'We have send it on your email ${widget.email}',
                        style: AppTextStyles.hintText.copyWith(
                          color: AppColors.cream,
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // OTP Input Boxes - cream/parchment color
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(8, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: 38,
                            height: 45,
                            decoration: BoxDecoration(
                              color: AppColors.cream,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                otpDigits[index],
                                style: AppTextStyles.mainTitle.copyWith(
                                  color: AppColors.blue,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 12),
                      
                      // Timer text
                      Center(
                        child: Text(
                          'This code will expire in 5 minutes',
                          style: AppTextStyles.hintText,
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Custom Numpad with parchment text
                      Expanded(
                        child: CustomNumpad(
                          onNumberTap: _onNumberTap,
                          onDelete: _onDelete,
                        ),
                      ),
                      
                      // Continue Button - cream/parchment color
                      _isLoading
                          ? const Center(child: CircularProgressIndicator(color: AppColors.cream))
                          : CustomButton(
                              text: 'Continue',
                              backgroundColor: AppColors.cream,
                              textColor: AppColors.blue,
                              onPressed: _handleVerifyOTP,
                            ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}