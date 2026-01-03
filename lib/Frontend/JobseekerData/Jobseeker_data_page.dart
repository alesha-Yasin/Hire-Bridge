import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/LoginPages/app_text_styles.dart';
import 'package:hirebridge/Frontend/UserData/reusable_data_widgets.dart';
import 'package:hirebridge/Frontend/JobseekerData/reusable_Jobseeker_widgets.dart';

class JobseekerDataPage extends StatefulWidget {
  const JobseekerDataPage({super.key});

  @override
  State<JobseekerDataPage> createState() => _JobseekerDataPageState();
}

class _JobseekerDataPageState extends State<JobseekerDataPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  // Controllers
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _resumeController = TextEditingController();
  final TextEditingController _portfolioController = TextEditingController();

  String? _desiredJobType;
  String? _availabilityStatus;

  @override
  void dispose() {
    _pageController.dispose();
    _educationController.dispose();
    _skillsController.dispose();
    _bioController.dispose();
    _experienceController.dispose();
    _salaryController.dispose();
    _resumeController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          const ScatteredJobseekerImages(),

          // Top-left corner decoration
          const Positioned(
            top: 0,
            left: 0,
            child: TopLeftCornerDecoration(),
          ),
          const Positioned(
            bottom: 0,
            right: 5,
            child: BottomRightCornerDecoration(),
          ),

          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),

                // Title "Create Profile"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Create Profile',
                    style: AppTextStyles.appBarTitle.copyWith(
                      color: AppColors.blue,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // PageView for forms
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) {
                      setState(() => _currentPage = page);
                    },
                    children: [
                      _buildPage1(),
                      _buildPage2(),
                      _buildPage3(),
                    ],
                  ),
                ),

                // Bottom navigation
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back arrow
                      GestureDetector(
                        onTap: () {
                          if (_currentPage > 0) {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: const Icon(
                          Icons.chevron_left,
                          color: AppColors.blue,
                          size: 32,
                        ),
                      ),

                      // Page indicators
                      PageIndicatorDots(
                        totalPages: _totalPages,
                        currentPage: _currentPage,
                      ),

                      // NEXT button
                      GestureDetector(
                        onTap: () {
                          if (_currentPage < _totalPages - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _submitProfile();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'NEXT',
                            style: AppTextStyles.buttonTexts.copyWith(
                              color: AppColors.cream,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Page 1: Education, Skills, Desired Job Type, Bio
  Widget _buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: JobseekerFormContainer(
        child: Column(
          children: [
            JobseekerFormField(
              label: 'Education Level',
              controller: _educationController,
            ),
            JobseekerFormField(
              label: 'Skills List',
              controller: _skillsController,
              suffixIcon: Icons.add_circle_outline,
            ),
            SearchableJobseekerDropdown(
              label: 'DesiredJob Type',
              value: _desiredJobType,
              options: const [
                'Full Time',
                'Part Time',
                'Remote',
                'Internship',
                'Contract',
              ],
              onSelected: (val) => setState(() => _desiredJobType = val),
            ),
            JobseekerFormField(
              label: 'Bio',
              controller: _bioController,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  // Page 2: Experience, Salary, Resume URL, Portfolio URL, Availability
  Widget _buildPage2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: JobseekerFormContainer(
        child: Column(
          children: [
            JobseekerFormField(
              label: 'Experience Years',
              controller: _experienceController,
            ),
            JobseekerFormField(
              label: 'Desired Salary',
              controller: _salaryController,
            ),
            JobseekerFormField(
              label: 'Resume URL',
              controller: _resumeController,
            ),
            JobseekerFormField(
              label: 'Portfolio URL',
              controller: _portfolioController,
            ),
            SearchableJobseekerDropdown(
              label: 'Availability Status',
              value: _availabilityStatus,
              options: const [
                'Available',
                'Not Available',
                'Open to Opportunities',
              ],
              onSelected: (val) => setState(() => _availabilityStatus = val),
            ),
          ],
        ),
      ),
    );
  }

  // Page 3: Profile Photo Upload
  Widget _buildPage3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: JobseekerFormContainer(
        child: Column(
          children: [
            const SizedBox(height: 40),
            ProfilePhotoUpload(
              onTap: () {
                // Handle photo upload
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Photo upload coming soon!'),
                    backgroundColor: AppColors.blue,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile Created Successfully!'),
        backgroundColor: AppColors.greenSuccess,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    // Navigate back to home/main screen
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
