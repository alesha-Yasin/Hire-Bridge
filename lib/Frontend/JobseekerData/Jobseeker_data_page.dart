import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/LoginPages/app_text_styles.dart';
import 'package:hirebridge/Frontend/UserData/reusable_data_widgets.dart';
import 'package:hirebridge/Frontend/JobseekerData/reusable_Jobseeker_widgets.dart';
import 'package:hirebridge/Frontend/Profile/jobseeker_profile_page.dart';
import 'package:hirebridge/models/JobSeeker.dart';
import 'package:hirebridge/models/User.dart' as model;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:hirebridge/services/supabase_storage_service.dart';


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
  final TextEditingController _headlineController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _resumeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _currentPosition;
  String? _desiredJobType;
  String? _availabilityStatus;
  List<String> _educationLevels = [];
  List<String> _skillsList = [];
  bool _isLoading = false;
  
  // File upload states
  String? _profilePhotoPath;
  String? _resumePath;

  // Image Picking
  Future<void> _pickProfilePhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profilePhotoPath = image.path;
      });
    }
  }

  // File Picking
  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _resumePath = result.files.single.path;
        _resumeController.text = p.basename(_resumePath!);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _headlineController.dispose();
    _aboutController.dispose();
    _experienceController.dispose();
    _salaryController.dispose();
    _resumeController.dispose();
    _addressController.dispose();
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
                if (_isLoading)
                  const LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
                  ),
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

  // Page 1: Education Level, Skills List, Headline, About
  Widget _buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: JobseekerFormContainer(
        child: Column(
          children: [
            DynamicItemField(
              label: 'Education Level',
              items: _educationLevels,
              onChanged: (newList) => setState(() => _educationLevels = newList),
              hintText: 'Add an education level...',
            ),
            DynamicItemField(
              label: 'Skills List',
              items: _skillsList,
              onChanged: (newList) => setState(() => _skillsList = newList),
              hintText: 'Add a skill...',
            ),
            JobseekerFormField(
              label: 'HeadLine',
              controller: _headlineController,
            ),
            JobseekerFormField(
              label: 'Address',
              controller: _addressController,
              hintText: 'Enter your address...',
            ),
            JobseekerFormField(
              label: 'About',
              controller: _aboutController,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }

  // Page 2: Experience Years, Current Position, Resume /cv, Availability Status
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
            SearchableJobseekerDropdown(
              label: 'Current position',
              value: _currentPosition,
              hintText: 'industry',
              options: const [
                'Software Engineering',
                'Design',
                'Marketing',
                'Sales',
                'Human Resources',
                'Finance',
                'Other',
              ],
              onSelected: (val) => setState(() => _currentPosition = val),
            ),
            JobseekerFormField(
              label: 'Resume /cv',
              controller: _resumeController,
              suffixIcon: Icons.add_circle_outline,
              readOnly: true,
              onTap: _pickResume,
            ),
            SearchableJobseekerDropdown(
              label: 'Availaility Status',
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
              imagePath: _profilePhotoPath,
              onTap: _pickProfilePhoto,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? profileImageUrl;
      String? resumeUrl;

      // 1. Upload Profile Photo if exists
      if (_profilePhotoPath != null) {
        profileImageUrl = await SupabaseStorageService.uploadProfilePhoto(
          _profilePhotoPath!,
          user.id,
        );
      }

      // 2. Upload Resume if exists
      if (_resumePath != null) {
        resumeUrl = await SupabaseStorageService.uploadResume(
          _resumePath!,
          user.id,
        );
      }

      final profile = JobSeekerProfile(
        seekerId: const Uuid().v4(),
        userId: user.id,
        bio: _aboutController.text,
        educationLevel: _educationLevels,
        skillsList: _skillsList,
        experienceYears: int.tryParse(_experienceController.text),
        headline: _headlineController.text,
        about: _aboutController.text,
        currentPosition: _currentPosition,
        desiredSalary: _salaryController.text,
        desiredJobType: _desiredJobType,
        resumeUrl: resumeUrl ?? _resumeController.text,
        address: _addressController.text,
        availabilityStatus: _availabilityStatus,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Update the user's profile image URL in the users table as well if needed
      if (profileImageUrl != null) {
        final currentUser = await model.User.fetchUser(user.id);
        if (currentUser != null) {
          final updatedUser = model.User(
            userId: currentUser.userId,
            firstName: currentUser.firstName,
            lastName: currentUser.lastName,
            gender: currentUser.gender,
            dateOfBirth: currentUser.dateOfBirth,
            phone: currentUser.phone,
            city: currentUser.city,
            country: currentUser.country,
            profileImage: profileImageUrl,
            address: currentUser.address,
            accountType: currentUser.accountType,
            createdAt: currentUser.createdAt,
            updatedAt: DateTime.now(),
          );
          await model.User.updateUser(updatedUser);
        }
      }

      await JobSeekerProfile.createProfile(profile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile Created Successfully!'),
            backgroundColor: AppColors.greenSuccess,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        // Navigate to JobSeeker Profile Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const JobSeekerProfilePage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
