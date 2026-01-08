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
  late TextEditingController _countryController;
  late TextEditingController _cityController;

  late List<String> _selectedPositions;
  final List<String> _marketPositions = [
    'Software Engineer',
    'Mobile App Developer',
    'UI/UX Designer',
    'Full Stack Developer',
    'Frontend Developer',
    'Backend Developer',
    'Data Scientist',
    'DevOps Engineer',
    'Product Manager',
    'QA Engineer',
    'Cybersecurity Analyst',
    'Cloud Architect',
    'AI/ML Engineer',
    'Game Developer',
  ];

  bool _isLoading = false;
  bool _showPositionSelection = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _headlineController = TextEditingController(text: widget.profile.headline);
    _selectedPositions = List<String>.from(widget.profile.currentPositions);
    _countryController = TextEditingController(text: widget.user.country);
    _cityController = TextEditingController(text: widget.user.city);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _headlineController.dispose();
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
        skillsList: widget.profile.skillsList,
        experienceYears: widget.profile.experienceYears,
        headline: _headlineController.text,
        about: widget.profile.about,
        currentPositions: _selectedPositions,
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
                  const SizedBox(height: 8),
                  const Text(
                    'Current Position',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPositionSelection(),
                  const SizedBox(height: 24),
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
  Widget _buildPositionSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white, width: 1.5)),
                ),
                child: _selectedPositions.isEmpty
                    ? const Text('Select your positions', style: TextStyle(color: Colors.white54, fontSize: 14))
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedPositions.map((p) => Chip(
                          label: Text(p, style: const TextStyle(color: Color(0xFF0F1633), fontSize: 12)),
                          backgroundColor: AppColors.cream,
                          deleteIcon: const Icon(Icons.close, size: 14, color: Color(0xFF0F1633)),
                          onDeleted: () {
                            setState(() {
                              _selectedPositions.remove(p);
                            });
                          },
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        )).toList(),
                      ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _showPositionSelection = !_showPositionSelection;
                });
              },
              icon: Icon(
                _showPositionSelection ? Icons.remove_circle_outline : Icons.add_circle_outline,
                color: Colors.white,
              ),
            ),
          ],
        ),
        if (_showPositionSelection) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F3C),
              borderRadius: BorderRadius.circular(12),
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _marketPositions.map((pos) {
                  final isSelected = _selectedPositions.contains(pos);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedPositions.remove(pos);
                        } else {
                          _selectedPositions.add(pos);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.cream : Colors.white10,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        pos,
                        style: TextStyle(
                          color: isSelected ? const Color(0xFF0F1633) : Colors.white70,
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
