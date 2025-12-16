import 'package:flutter/material.dart';
import 'package:hirebridge/utils/AppColors.dart';
import 'package:hirebridge/widgets/custom_button.dart';
import 'package:hirebridge/widgets/onboarding_content.dart';
import 'package:hirebridge/widgets/page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'image': 'assets/images/onboarding1.png',
      'title': 'find your dream\njob now',
      'description':
          'Your skills deserve the right place. Match instantly with trusted employers and start your journey today.',
    },
    {
      'image': 'assets/images/onboarding2.png',
      'title': 'EveryThink you need\nin one app',
      'description':
          '"We bring everything together: job search, AI-powered interviews, company verification, smart job matching, and post-hire task management, so your professional journey stays simple and powerful."',
    },
    {
      'image': 'assets/images/onboarding3.png',
      'title': 'Get Selectd for your\ndream job',
      'description':
          '"Increase your chances of getting hired with intelligent matching, clear skill analysis, and verified job listings that fit your goals and abilities."',
    },
  ];

  void _goToNextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bone,
      body: Stack(
        children: [
          // PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              final data = _onboardingData[index];
              return OnboardingContent(
                imagePath: data['image']!,
                title: data['title']!,
                description: data['description']!,
              );
            },
          ),
          // Bottom Navigation
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  _currentPage > 0
                      ? CustomButton(
                          icon: Icons.arrow_back,
                          onTap: _goToPreviousPage,
                        )
                      : const SizedBox(width: 56, height: 56),
                  // Page Indicators
                  PageIndicator(
                    currentPage: _currentPage,
                    totalPages: _onboardingData.length,
                  ),
                  // Next Button
                  CustomButton(
                    icon: Icons.arrow_forward,
                    onTap: _goToNextPage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}