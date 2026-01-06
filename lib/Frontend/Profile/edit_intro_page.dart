import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/Profile/reusable_profile_widgets.dart';
import 'package:hirebridge/Frontend/Profile/edit_contact_info_page.dart';
import 'package:hirebridge/models/JobSeeker.dart';
import 'package:hirebridge/models/User.dart' as model;

class EditIntroPage extends StatefulWidget {
  final model.User user;
  final JobSeekerProfile profile;

  const EditIntroPage({
    super.key,
    required this.user,
    required this.profile,
  });

  @override
  State<EditIntroPage> createState() => _EditIntroPageState();
}

class _EditIntroPageState extends State<EditIntroPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _headlineController;
  late TextEditingController _educationController;
  late TextEditingController _positionController;
  late TextEditingController _countryController;
  late TextEditingController _cityController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _headlineController = TextEditingController(text: widget.profile.headline);
    _educationController = TextEditingController(text: widget.profile.educationLevel?.join(', ') ?? '');
    _positionController = TextEditingController(text: widget.profile.currentPosition);
    _countryController = TextEditingController(text: widget.user.country);
    _cityController = TextEditingController(text: widget.user.city);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _headlineController.dispose();
    _educationController.dispose();
    _positionController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      // 1. Update User table
      final updatedUser = model.User(
        userId: widget.user.userId,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        gender: widget.user.gender,
        dateOfBirth: widget.user.dateOfBirth,
        phone: widget.user.phone,
        city: _cityController.text,
        country: _countryController.text,
        profileImage: widget.user.profileImage,
        address: widget.user.address,
        accountType: widget.user.accountType,
        createdAt: widget.user.createdAt,
        updatedAt: DateTime.now(),
      );
      await model.User.updateUser(updatedUser);

      // 2. Update JobSeekerProfile table
      final updatedProfile = JobSeekerProfile(
        seekerId: widget.profile.seekerId,
        userId: widget.profile.userId,
        bio: widget.profile.bio,
        educationLevel: _educationController.text.split(',').map((e) => e.trim()).toList(),
        skillsList: widget.profile.skillsList,
        experienceYears: widget.profile.experienceYears,
        headline: _headlineController.text,
        about: widget.profile.about,
        currentPosition: _positionController.text,
        desiredSalary: widget.profile.desiredSalary,
        desiredJobType: widget.profile.desiredJobType,
        resumeUrl: widget.profile.resumeUrl,
        profileUrl: widget.profile.profileUrl,
        address: widget.profile.address,
        internshipsCount: widget.profile.internshipsCount,
        projectsCount: widget.profile.projectsCount,
        projects: widget.profile.projects,
        detailedExperience: widget.profile.detailedExperience,
        availabilityStatus: widget.profile.availabilityStatus,
        createdAt: widget.profile.createdAt,
        updatedAt: DateTime.now(),
      );
      await JobSeekerProfile.updateProfile(updatedProfile);

      if (mounted) {
        Navigator.pop(context, true); // true indicates data was updated
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1633),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const EditSectionHeader(title: 'Edit intro'),
                  ModernEditTextField(
                    label: 'First Name',
                    controller: _firstNameController,
                  ),
                  ModernEditTextField(
                    label: 'Last Name',
                    controller: _lastNameController,
                  ),
                  ModernEditTextField(
                    label: 'HeadLine',
                    controller: _headlineController,
                    maxLines: 2,
                  ),
                  ModernEditTextField(
                    label: 'Education',
                    controller: _educationController,
                    suffixIcon: Icons.add_circle_outline,
                  ),
                  ModernEditTextField(
                    label: 'Current Position',
                    controller: _positionController,
                    suffixIcon: Icons.add_circle_outline,
                  ),
                  ModernEditTextField(
                    label: 'Country',
                    controller: _countryController,
                  ),
                  ModernEditTextField(
                    label: 'City',
                    controller: _cityController,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Contact Info',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Add or edit your profile URL, email and more',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditContactInfoPage(
                            user: widget.user,
                            profile: widget.profile,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Edit contact info',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator(color: AppColors.cream))
                  else
                    EditPageSaveButton(onPressed: _saveProfile),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
