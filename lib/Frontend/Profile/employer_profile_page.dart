import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/Profile/reusable_profile_widgets.dart';
import 'package:hirebridge/models/Employer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hirebridge/Frontend/Profile/settings_page.dart';
import 'package:hirebridge/Frontend/Profile/edits/edit_about_page.dart';

class EmployerProfilePage extends StatefulWidget {
  const EmployerProfilePage({super.key});

  @override
  State<EmployerProfilePage> createState() => _EmployerProfilePageState();
}

class _EmployerProfilePageState extends State<EmployerProfilePage> {
  bool _isLoading = true;
  Employer? _employer;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final supabaseUser = Supabase.instance.client.auth.currentUser;
    if (supabaseUser == null) return;

    try {
      final employer = await Employer.fetchByUserId(supabaseUser.id);

      setState(() {
        _employer = employer;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching employer profile: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.blue,
        body: Center(child: CircularProgressIndicator(color: AppColors.cream)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F1633),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Company Profile',
          style: TextStyle(color: AppColors.cream),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Company Header Card
            _buildHeaderCard(),
            const SizedBox(height: 20),

            // Company Description Card
            _buildDescriptionCard(),
            const SizedBox(height: 20),

            // Contact Info Card
            _buildContactCard(),
            const SizedBox(height: 20),

            // Verification Status Card
            _buildVerificationCard(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return ProfileSectionCard(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                // TODO: Navigate to edit employer profile
              },
              icon: const Icon(Icons.edit, color: Color(0xFF0F1633), size: 24),
            ),
          ),
          // Company Logo
          CircleAvatar(
            radius: 65,
            backgroundColor: const Color(0xFFB2B2B4),
            backgroundImage: _employer?.companyLogo != null
                ? NetworkImage(_employer!.companyLogo!)
                : null,
            child: _employer?.companyLogo == null
                ? const Icon(Icons.business, size: 65, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            _employer?.companyName ?? 'Company Name',
            style: const TextStyle(
              color: Color(0xFF0F1633),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _employer?.companyWebsite ?? 'Add company website',
            style: const TextStyle(
              color: Color(0xFF0F1633),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'About Company',
            onEdit: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditAboutPage(initialAbout: _employer?.companyDescription ?? ''),
                ),
              );
              if (result != null && _employer != null) {
                setState(() {
                  _employer = _employer!.copyWith(companyDescription: result as String);
                });
                _saveEmployer();
              }
            },
          ),
          const SizedBox(height: 12),
          Text(
            _employer?.companyDescription ?? 'Add company description...',
            style: const TextStyle(
              color: Color(0xFF0F1633),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: 'Contact Information', onEdit: () {}),
          const SizedBox(height: 12),
          _buildContactItem(Icons.email, 'Email', _employer?.companyEmail ?? 'Not provided'),
          const SizedBox(height: 8),
          _buildContactItem(Icons.phone, 'Phone', _employer?.companyPhone ?? 'Not provided'),
          const SizedBox(height: 8),
          _buildContactItem(Icons.location_on, 'Address', _employer?.companyAddress ?? 'Not provided'),
          const SizedBox(height: 8),
          _buildContactItem(Icons.language, 'Website', _employer?.companyWebsite ?? 'Not provided'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0F1633), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0x990F1633),
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF0F1633),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationCard() {
    final status = _employer?.companyVerificationStatus ?? 'Pending';
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'Verified':
        statusColor = Colors.green;
        statusIcon = Icons.verified;
        break;
      case 'Rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
    }

    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: 'Verification Status', onEdit: () {}),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 28),
              const SizedBox(width: 12),
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            status == 'Verified'
                ? 'Your company is verified and trusted by HireBridge.'
                : status == 'Rejected'
                    ? 'Your verification was rejected. Please contact support.'
                    : 'Your company verification is pending review.',
            style: const TextStyle(
              color: Color(0xFF0F1633),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveEmployer() async {
    if (_employer == null) return;
    try {
      await Employer.updateEmployer(_employer!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Company profile updated successfully!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving company profile: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
