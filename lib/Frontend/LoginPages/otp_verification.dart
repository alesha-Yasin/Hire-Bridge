import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/LoginPages/app_text_styles.dart';
import 'package:hirebridge/Frontend/LoginPages/reusable_widgets.dart';
import 'package:hirebridge/Frontend/LoginPages/create_new_password.dart';
class OtpVerificationPage extends StatefulWidget {
  final String verificationType; // 'Email' or 'SMS'

  const OtpVerificationPage({
    Key? key,
    required this.verificationType,
  }) : super(key: key);

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<String> otpDigits = ['', '', '', ''];
  int currentIndex = 0;

  void _onNumberTap(String number) {
    if (currentIndex < 4) {
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
                            : 'We have send it on your email xyz@gmail.com',
                        style: AppTextStyles.hintText.copyWith(
                          color: AppColors.cream,
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // OTP Input Boxes - cream/parchment color
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              color: AppColors.cream,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                otpDigits[index],
                                style: AppTextStyles.mainTitle.copyWith(
                                  color: AppColors.blue,
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
                      CustomButton(
                        text: 'Continue',
                        backgroundColor: AppColors.cream,
                        textColor: AppColors.blue,
                        onPressed: () {
                          if (isOtpComplete()) {
                            // Navigate to Create New Password page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreateNewPasswordPage(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter complete OTP'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
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