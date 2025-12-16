import 'package:flutter/material.dart';
import 'package:hirebridge/utils/AppColors.dart';
import 'package:hirebridge/widgets/app_logo.dart';

class OnboardingContent extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingContent({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bone,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const SizedBox(height: 60),
          // Logo at top
          const AppLogo(height: 40),
          const Spacer(flex: 2),
          // Illustration
          Image.asset(
            imagePath,
            width: 280,
            height: 280,
            fit: BoxFit.contain,
          ),
          const Spacer(flex: 2),
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: AppColors.prussianBlue,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.prussianBlue,
              height: 1.5,
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}