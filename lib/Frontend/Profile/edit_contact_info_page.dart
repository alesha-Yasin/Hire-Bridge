import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/Profile/reusable_profile_widgets.dart';
import 'package:hirebridge/models/JobSeeker.dart';
import 'package:hirebridge/models/User.dart' as model;
import 'package:hirebridge/services/supabase_storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class EditContactInfoPage extends StatefulWidget {
  final model.User user;
  final JobSeekerProfile profile;

  const EditContactInfoPage({
    super.key,
    required this.user,
    required this.profile,
  });

  @override
  State<EditContactInfoPage> createState() => _EditContactInfoPageState();
}

class _EditContactInfoPageState extends State<EditContactInfoPage> {
  late TextEditingController _profileUrlController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _birthdayController;

  DateTime? _selectedBirthday;
  String? _resumePath;
  String? _resumeUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _profileUrlController = TextEditingController(text: widget.profile.profileUrl);
    // Note: Email is handled by Supabase Auth, but we show it here as read-only contact data
    _emailController = TextEditingController(text: 'aleshayasin2004@gmail.com'); // Placeholder or from user
    _phoneController = TextEditingController(text: widget.user.phone);
    _addressController = TextEditingController(text: widget.user.address);
    _selectedBirthday = widget.user.dateOfBirth;
    _birthdayController = TextEditingController(
      text: _selectedBirthday != null ? DateFormat('dd/MM/yyyy').format(_selectedBirthday!) : '',
    );
    _resumeUrl = widget.profile.resumeUrl;
  }

  @override
  void dispose() {
    _profileUrlController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthday() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.cream,
              onPrimary: AppColors.blue,
              surface: AppColors.blue,
              onSurface: AppColors.cream,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedBirthday = picked;
        _birthdayController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      setState(() {
        _resumePath = result.files.single.path;
      });
    }
  }

  Future<void> _saveContactInfo() async {
    setState(() => _isLoading = true);
    try {
      String? uploadedResumeUrl = _resumeUrl;

      // Upload resume if a new one was picked
      if (_resumePath != null) {
        uploadedResumeUrl = await SupabaseStorageService.uploadFile(
          bucket: 'resumes',
          filePath: _resumePath!,
          fileName: 'resume_${widget.user.userId}',
        );
      }

      // 1. Update User table
      final updatedUser = model.User(
        userId: widget.user.userId,
        firstName: widget.user.firstName,
        lastName: widget.user.lastName,
        gender: widget.user.gender,
        dateOfBirth: _selectedBirthday,
        phone: _phoneController.text,
        city: widget.user.city,
        country: widget.user.country,
        profileImage: widget.user.profileImage,
        address: _addressController.text,
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
        educationLevel: widget.profile.educationLevel,
        skillsList: widget.profile.skillsList,
        experienceYears: widget.profile.experienceYears,
        headline: widget.profile.headline,
        about: widget.profile.about,
        currentPosition: widget.profile.currentPosition,
        desiredSalary: widget.profile.desiredSalary,
        desiredJobType: widget.profile.desiredJobType,
        resumeUrl: uploadedResumeUrl,
        profileUrl: _profileUrlController.text,
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
        // Pop back twice to get to profile page, or once but use a signal
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving contact info: $e')),
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
                  const EditSectionHeader(title: 'Edit contact info'),
                  ModernEditTextField(
                    label: 'Profile URL',
                    controller: _profileUrlController,
                    hintText: 'https://linkedin.com/...',
                  ),
                  ModernEditTextField(
                    label: 'Email',
                    controller: _emailController,
                    readOnly: true,
                  ),
                  ModernEditTextField(
                    label: 'Phone number',
                    controller: _phoneController,
                  ),
                  ModernEditTextField(
                    label: 'Address',
                    controller: _addressController,
                  ),
                  ModernEditTextField(
                    label: 'Birthday',
                    controller: _birthdayController,
                    readOnly: true,
                    suffixIcon: Icons.calendar_month,
                    onSuffixTap: _pickBirthday,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Resume (doc)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildResumeItem(),
                  const SizedBox(height: 45),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator(color: AppColors.cream))
                  else
                    EditPageSaveButton(onPressed: _saveContactInfo),
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

  Widget _buildResumeItem() {
    String fileName = 'No file chosen';
    if (_resumePath != null) {
      fileName = _resumePath!.split('/').last;
    } else if (_resumeUrl != null) {
      fileName = 'Current Resume.pdf';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white24, width: 1.0)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _pickResume,
            icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 24),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              fileName,
              style: const TextStyle(color: Colors.white, fontSize: 13, decoration: TextDecoration.underline),
            ),
          ),
          if (_resumePath != null || _resumeUrl != null)
            IconButton(
              onPressed: () {
                setState(() {
                  _resumePath = null;
                  _resumeUrl = null;
                });
              },
              icon: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
            ),
        ],
      ),
    );
  }
}
