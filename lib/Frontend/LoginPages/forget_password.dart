import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/app_text_styles.dart';
import 'package:hirebridge/Frontend/LoginPages/reusable_widgets.dart';
import 'package:hirebridge/Frontend/LoginPages/recovery_email.dart';
import 'package:hirebridge/Frontend/LoginPages/recovery_sms.dart';
class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  int selectedOption = 0; // 0 = email, 1 = SMS

  @override
  Widget build(BuildContext context) {
    return Decore(
      title: 'Forget Password',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // Title
            Text(
              'Forget Password',
              style: AppTextStyles.mainTitle.copyWith(
                
              ),
            ),
            const SizedBox(height: 8),
            
            // Subtitle
            const Text(
              'Please select option to send link reset password',
              style: AppTextStyles.hintText,
            ),
            const SizedBox(height: 30),
            
            // Select Option label
            const Text(
              'Select Option',
              style: AppTextStyles.subheading,
            ),
            const SizedBox(height: 16),
            
            // Email Option
            ResetOptionCard(
              icon: Icons.email_outlined,
              title: 'Reset via email',
              subtitle: 'If you have email linked to account',
              isSelected: selectedOption == 0,
              onTap: () {
                setState(() {
                  selectedOption = 0;
                });
                // Navigate to email recovery
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RecoveryEmailPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            
            // SMS Option
            ResetOptionCard(
              icon: Icons.phone_android,
              title: 'Reset via SMS',
              subtitle: 'If you have number linked to account',
              isSelected: selectedOption == 1,
              onTap: () {
                setState(() {
                  selectedOption = 1;
                });
                // Navigate to SMS recovery
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RecoverySmsPage(),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}