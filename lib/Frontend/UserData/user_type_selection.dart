import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/UserData/reusable_data_widgets.dart';
import 'package:hirebridge/Frontend/UserData/user_details_page.dart';
import 'package:hirebridge/Frontend/LoginPages/login_page.dart';

class UserTypeSelection extends StatefulWidget {
  const UserTypeSelection({super.key});

  @override
  State<UserTypeSelection> createState() => _UserTypeSelectionState();
}

class _UserTypeSelectionState extends State<UserTypeSelection> {
  String? selectedType;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          // Blue top section
          Container(
            height: screenHeight * 0.52,
            width: double.infinity,
            color: AppColors.blue,
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, top: 12),
                    child: BackArrowButton(
                      color: AppColors.cream,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                    ),
                  ),
                ),

                // Assign icon (3-person group)
                SizedBox(height: screenHeight * 0.06),
                Image.asset(
                  'assets/images/assign 1.png',
                  width: 180,
                  height: 180,
                  color: AppColors.cream,
                ),

                // Spacer to push content down
                SizedBox(height: screenHeight * 0.02),

                // Two circles decoration - RIGHT SIDE, TOUCHING
                SizedBox(
                  height: 100,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Cream circle (left, touching)
                      Positioned(
                        right: 80, // positioned to touch blue circle
                        top: 60,
                        child: const DecorativeCircle(
                          backgroundColor: AppColors.cream,
                          iconColor: AppColors.blue,
                          icon: Icons.keyboard_arrow_up,
                          size: 80,
                        ),
                      ),
                      // Blue circle (right)
                      Positioned(
                        right: 1,
                        top: 60,
                        child: const DecorativeCircle(
                          backgroundColor: AppColors.blue,
                          iconColor: AppColors.cream,
                          icon: Icons.keyboard_arrow_down,
                          size: 80,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Selection cards in cream section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        
                        // Job Seeker Card
                        SelectionCard(
                          title: 'JOB SEEKER',
                          subtitle: "Let's recruit your great\ncandidate faster here",
                          iconPath: 'assets/images/jobSeeker.png',
                          isSelected: selectedType == 'job_seeker',
                          onTap: () {
                            setState(() => selectedType = 'job_seeker');
                            _navigateToDetails();
                          },
                        ),

                        const SizedBox(height: 16),

                        // Company Card
                        SelectionCard(
                          title: 'COMPANY',
                          subtitle: "Let's recruit your great\ncandidate faster here",
                          iconPath: 'assets/images/company.png',
                          isSelected: selectedType == 'company',
                          onTap: () {
                            setState(() => selectedType = 'company');
                            _navigateToDetails();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetails() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailsPage(userType: selectedType!),
          ),
        );
      }
    });
  }
}
