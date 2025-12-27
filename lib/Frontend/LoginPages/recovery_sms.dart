import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/app_text_styles.dart';
import 'package:hirebridge/Frontend/LoginPages/reusable_widgets.dart';
import 'package:hirebridge/Frontend/LoginPages/otp_verification.dart';
class RecoverySmsPage extends StatefulWidget {
  const RecoverySmsPage({Key? key}) : super(key: key);

  @override
  State<RecoverySmsPage> createState() => _RecoverySmsPageState();
}

class _RecoverySmsPageState extends State<RecoverySmsPage> {
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneController.dispose();
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
                'Recovery from SMS',
                style: AppTextStyles.mainTitle.copyWith(
                  
                ),
              ),
              const SizedBox(height: 8),
              
              // Subtitle
              const Text(
                'We will send password recovery code on this phone number.',
                style: AppTextStyles.hintText,
              ),
              const SizedBox(height: 40),
              
              // Phone Number label
              const Text(
                'Enter Number',
                style: AppTextStyles.subheading,
              ),
              const SizedBox(height: 12),
              
              // Phone TextField (dark background with check icon)
              CustomTextField(
                controller: phoneController,
                hintText: '',
                showCheckIcon: true,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 40),
              
              // Send Link Recovery Button
              CustomButton(
                text: 'Send Link Recovery',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OtpVerificationPage(
                          verificationType: 'SMS',
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}