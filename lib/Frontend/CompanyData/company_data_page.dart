import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/LoginPages/app_text_styles.dart';
import 'package:hirebridge/Frontend/UserData/reusable_data_widgets.dart';
import 'package:hirebridge/Frontend/CompanyData/reusable_company_widgets.dart' hide ProfilePhotoUpload;
import 'package:hirebridge/models/Employer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hirebridge/services/supabase_storage_service.dart';
import 'package:hirebridge/Frontend/JobseekerData/reusable_Jobseeker_widgets.dart' show ProfilePhotoUpload;


class CompanyDataPage extends StatefulWidget {
  const CompanyDataPage({super.key});

  @override
  State<CompanyDataPage> createState() => _CompanyDataPageState();
}

class _CompanyDataPageState extends State<CompanyDataPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _verificationStatus = 'Pending';
  bool _isLoading = false;
  String? _logoPath;

  // Image Picking
  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _logoPath = image.path;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          const ScatteredCompanyImages(),

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

  // Page 1: Name, Email, Phone, Address, Website
  Widget _buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: CompanyFormContainer(
        child: Column(
          children: [
            CompanyFormField(
              label: 'Company Name',
              controller: _nameController,
            ),
            CompanyFormField(
              label: 'Company Email',
              controller: _emailController,
            ),
            CompanyFormField(
              label: 'Company phone number',
              controller: _phoneController,
              suffixIcon: Icons.add_circle_outline,
            ),
            CompanyFormField(
              label: 'Company Address',
              controller: _addressController,
            ),
            CompanyFormField(
              label: 'Company Website',
              controller: _websiteController,
            ),
          ],
        ),
      ),
    );
  }

  // Page 2: Description, Verification Status
  Widget _buildPage2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: CompanyFormContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CompanyFormField(
              label: 'Company Description',
              controller: _descriptionController,
              maxLines: 5,
            ),
            const SizedBox(height: 10),
            VerificationStatusSelector(
              selectedStatus: _verificationStatus,
              onChanged: (val) => setState(() => _verificationStatus = val),
            ),
          ],
        ),
      ),
    );
  }

  // Page 3: Logo Upload
  Widget _buildPage3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CompanyFormContainer(
        child: Column(
          children: [
            const SizedBox(height: 40),
            ProfilePhotoUpload(
              imagePath: _logoPath,
              onTap: _pickLogo,
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
      String? logoUrl;

      // 1. Upload Logo if exists
      if (_logoPath != null) {
        logoUrl = await SupabaseStorageService.uploadFile(
          bucket: 'profiles', // Using profiles bucket for logos too, or create a 'logos' one
          filePath: _logoPath!,
          fileName: 'logo_${user.id}',
        );
      }

      final employer = Employer(
        employerId: const Uuid().v4(),
        userId: user.id,
        companyName: _nameController.text,
        companyEmail: _emailController.text,
        companyPhone: _phoneController.text,
        companyAddress: _addressController.text,
        companyWebsite: _websiteController.text,
        companyDescription: _descriptionController.text,
        companyLogo: logoUrl,
        companyVerificationStatus: _verificationStatus ?? 'Pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await Employer.createEmployer(employer);

      if (mounted) {
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
