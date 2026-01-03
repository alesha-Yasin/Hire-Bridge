import 'package:flutter/material.dart';
import 'package:hirebridge/auth/auth_service.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/LoginPages/app_text_styles.dart';
import 'package:hirebridge/Frontend/LoginPages/reusable_widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final userEmail = authService.currentUserEmail ?? 'User';

    return Decore(
      title: 'Profile',
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_circle,
              size: 100,
              color: AppColors.cream,
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome!',
              style: AppTextStyles.mainTitle.copyWith(color: AppColors.cream),
            ),
            const SizedBox(height: 8),
            Text(
              userEmail,
              style: AppTextStyles.subheading.copyWith(color: AppColors.cream),
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Sign Out',
              onPressed: () async {
                await authService.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
