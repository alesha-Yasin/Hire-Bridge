import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/LoginPages/app_text_styles.dart';
import 'package:hirebridge/Frontend/LoginPages/reusable_widgets.dart';
import 'package:hirebridge/Frontend/LoginPages/login_page.dart';
class IntroPages extends StatefulWidget {
  const IntroPages({Key? key}) : super(key: key);

  @override
  State<IntroPages> createState() => _IntroPagesState();
}

class _IntroPagesState extends State<IntroPages> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: 'find your dream job now',
      subtitle: 'Your skills deserve the right place. Match instantly with trusted employers and start your journey today.',
      image: 'assets/images/onboarding1.png',
    ),
    OnboardingData(
      title: 'EveryThink you need in one app',
      subtitle: '"We bring everything together: job search, AI-powered interviews, company verification, smart job matching, and post-hire task management so your professional journey stays simple and powerful."',
      image: 'assets/images/onboarding2.png',
    ),
    OnboardingData(
      title: 'Get Selectd for your dream job',
      subtitle: '"Increase your chances of getting hired with intelligent matching, clear skill analysis, and verified job listings that fit your goals and abilities."',
      image: 'assets/images/onboarding3.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // If it's a "splash" state, we could show something else, 
    // but the design shows 3 intro pages after the splash.
    // I will implement the 3 pages shown in the design.
    
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Logo Header
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: HireBridgeLogo(
                  isSmall: true,
                  width: 120,
                ),
              ),
            ),
            
            // PageView Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration
                        Image.asset(
                          data.image,
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 40),
                        
                        // Title
                        Text(
                          data.title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.verySmallHeading.copyWith(
                            fontSize: 32,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Subtitle
                        Text(
                          data.subtitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.verySmallText.copyWith(
                            fontSize: 14,
                            color: AppColors.blue.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Bottom Controls
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button (hidden on first page)
                  if (_currentPage > 0)
                    CircleIconButton(
                      icon: Icons.arrow_back,
                      onPressed: _previousPage,
                    )
                  else
                    const SizedBox(width: 48),
                  
                  // Indicators
                  OnboardingIndicator(
                    total: _onboardingData.length,
                    current: _currentPage,
                  ),
                  
                  // Next Button
                  CircleIconButton(
                    icon: Icons.arrow_forward,
                    onPressed: _nextPage,
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

class OnboardingData {
  final String title;
  final String subtitle;
  final String image;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}

