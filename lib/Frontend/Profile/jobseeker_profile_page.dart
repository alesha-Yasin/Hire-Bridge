import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/Profile/reusable_profile_widgets.dart';
import 'package:hirebridge/Frontend/Profile/edit_intro_page.dart';
import 'package:hirebridge/models/JobSeeker.dart';
import 'package:hirebridge/models/User.dart' as model;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hirebridge/Frontend/Profile/settings_page.dart';
import 'package:hirebridge/Frontend/Profile/edits/edit_about_page.dart';
import 'package:hirebridge/Frontend/Profile/edits/edit_skills_page.dart';
import 'package:hirebridge/Frontend/Profile/edits/edit_projects_page.dart';
import 'package:hirebridge/Frontend/Profile/edits/edit_education_page.dart';
import 'package:hirebridge/Frontend/Profile/edits/edit_experience_page.dart';
import 'package:hirebridge/models/jobseeker_edit_models.dart';

class JobSeekerProfilePage extends StatefulWidget {
  const JobSeekerProfilePage({super.key});

  @override
  State<JobSeekerProfilePage> createState() => _JobSeekerProfilePageState();
}

class _JobSeekerProfilePageState extends State<JobSeekerProfilePage> {
  bool _isLoading = true;
  model.User? _user;
  JobSeekerProfile? _profile;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final supabaseUser = Supabase.instance.client.auth.currentUser;
    if (supabaseUser == null) return;

    try {
      final user = await model.User.fetchUser(supabaseUser.id);
      final profile = await JobSeekerProfile.fetchByUserId(supabaseUser.id);

      setState(() {
        _user = user;
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching profile: $e');
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
      backgroundColor: const Color(0xFF0F1633), // Dark navy from screenshot
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'JobSeeker Profile',
          style: TextStyle(color: AppColors.cream),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color:AppColors.cream),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.cream),
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
            // Top Section (Header)
            _buildHeaderCard(),
            const SizedBox(height: 20),

            // About Section
            _buildAboutCard(),
            const SizedBox(height: 20),

            // Education Section
            _buildEducationCard(),
            const SizedBox(height: 20),

            // Skills Section
            _buildSkillsCard(),
            const SizedBox(height: 20),

            // Projects Section
            _buildProjectsCard(),
            const SizedBox(height: 20),

            // Experience Section
            _buildExperienceCard(),
            const SizedBox(height: 20),

            // Address Section
            _buildAddressCard(),
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
              onPressed: () async {
                if (_user != null && _profile != null) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditIntroPage(
                        user: _user!,
                        profile: _profile!,
                      ),
                    ),
                  );
                  if (result == true) {
                    _fetchProfileData(); // Refresh data
                  }
                }
              },
              icon: const Icon(Icons.edit, color: Color(0xFF0F1633), size: 24),
            ),
          ),
          CircleAvatar(
            radius: 65,
            backgroundColor: const Color(0xFFB2B2B4),
            backgroundImage: _user?.profileImage != null
                ? NetworkImage(_user!.profileImage!)
                : null,
            child: _user?.profileImage == null
                ? const Icon(Icons.person, size: 65, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            '${_user?.firstName ?? ''} ${_user?.lastName ?? ''}',
            style: const TextStyle(
              color: Color(0xFF0F1633),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _profile?.headline ?? 'Add a headline',
            style: const TextStyle(
              color: Color(0xFF0F1633),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('Experience', '${_profile?.experienceYears ?? 0}'),
              _buildStatItem('Internship', '${_profile?.internshipsCount ?? 0}'),
              _buildStatItem('Projects', '${_profile?.projectsCount ?? 0}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F1633),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F1633),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutCard() {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'About',
            onEdit: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditAboutPage(initialAbout: _profile?.about ?? ''),
                ),
              );
              // Handle result (frontend only for now as requested)
              if (result != null && _profile != null) {
                setState(() {
                  _profile = _profile!.copyWith(about: result as String);
                });
                _saveProfile();
              }
            },
          ),
          const SizedBox(height: 12),
          Text(
            _profile?.about ?? 'Tell us about yourself...',
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

  Widget _buildEducationCard() {
    final hasEducation = _profile?.educationLevel != null && _profile!.educationLevel!.isNotEmpty;
    
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'Education',
            onEdit: () => _navigateToEducationEdit(context),
            onAdd: () => _navigateToEducationEdit(context),
          ),
          const SizedBox(height: 12),
          if (hasEducation)
            ..._profile!.educationLevel!.map((edu) => _buildEducationItem(edu))
          else
            const Text('Add your education history...', style: TextStyle(color: Color(0xFF0F1633), fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildSkillsCard() {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'Skills',
            onEdit: () => _navigateToSkillsEdit(context),
            onAdd: () => _navigateToSkillsEdit(context),
          ),
          const SizedBox(height: 12),
          if (_profile?.skillsList != null && _profile!.skillsList!.isNotEmpty)
            ..._profile!.skillsList!.map((skill) => _buildSkillDetailItem(skill))
          else
            const Text('Add your professional skills...', style: TextStyle(color: Color(0xFF0F1633), fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildProjectsCard() {
    final hasProjects = _profile?.projects != null && _profile!.projects!.isNotEmpty;
    
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'Projects',
            onEdit: () => _navigateToProjectsEdit(context),
            onAdd: () => _navigateToProjectsEdit(context),
          ),
          const SizedBox(height: 12),
          if (hasProjects)
            ..._profile!.projects!.map((p) => _buildProjectItem(p))
          else
            const Text('Share your amazing projects here...', style: TextStyle(color: Color(0xFF0F1633), fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildExperienceCard() {
    final hasExp = _profile?.detailedExperience != null && _profile!.detailedExperience!.isNotEmpty;

    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'Experience',
            onEdit: () => _navigateToExperienceEdit(context),
            onAdd: () => _navigateToExperienceEdit(context),
          ),
          const SizedBox(height: 12),
          if (hasExp)
            ..._profile!.detailedExperience!.map((exp) => _buildExperienceItem(exp))
          else
            const Text('Add your professional experience...', style: TextStyle(color: Color(0xFF0F1633), fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildAddressCard() {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: 'Address', onEdit: () {}),
          const SizedBox(height: 12),
          Text(
            _profile?.address ?? 'No address provided',
            style: const TextStyle(color: Color(0xFF0F1633), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationItem(dynamic edu) {
    final title = edu is Map ? edu['degree'] ?? 'Degree' : edu.toString();
    final subtitle = edu is Map ? '${edu['institution'] ?? 'Institution'} • ${edu['year'] ?? ''}' : '';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Color(0xFF0F1633), fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            ],
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: const TextStyle(color: Color(0x990F1633), fontSize: 12),
            ),
          const Divider(color: Color(0xFF0F1633), thickness: 0.5),
        ],
      ),
    );
  }

  Widget _buildProjectItem(dynamic project) {
    final title = project is Map ? project['name'] ?? 'Project' : project.toString();
    final desc = project is Map ? project['description'] ?? '' : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Color(0xFF0F1633), fontWeight: FontWeight.w600, fontSize: 14),
          ),
          if (desc.isNotEmpty)
            Text(
              desc,
              style: const TextStyle(color: Color(0x990F1633), fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          const Divider(color: Color(0xFF0F1633), thickness: 0.5),
        ],
      ),
    );
  }

  Widget _buildSkillDetailItem(dynamic skill) {
    final name = skill is Map ? skill['name'] ?? '' : skill.toString();
    final project = skill is Map ? skill['projectName'] ?? '' : '';
    final tools = skill is Map ? skill['workWith'] ?? '' : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(color: Color(0xFF0F1633), fontWeight: FontWeight.bold, fontSize: 15),
          ),
          if (project.isNotEmpty)
            Text('Project: $project', style: const TextStyle(color: Color(0x990F1633), fontSize: 12)),
          if (tools.isNotEmpty)
            Text('Tools: $tools', style: const TextStyle(color: Color(0x990F1633), fontSize: 12)),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFF0F1633), thickness: 0.5),
        ],
      ),
    );
  }

  Widget _buildExperienceItem(dynamic exp) {
    final company = exp is Map ? exp['company'] ?? 'Company' : exp.toString();
    final role = exp is Map ? exp['role'] ?? '' : '';
    final period = exp is Map ? exp['period'] ?? '' : '';
    final desc = exp is Map ? exp['description'] ?? '' : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 18, backgroundColor: Colors.grey[200], child: const Icon(Icons.business, size: 18, color: Color(0xFF0F1633))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company,
                      style: const TextStyle(color: Color(0xFF0F1633), fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    if (role.isNotEmpty)
                      Text(
                        role,
                        style: const TextStyle(color: Color(0xFF0F1633), fontWeight: FontWeight.w500, fontSize: 13),
                      ),
                  ],
                ),
              ),
              if (period.isNotEmpty)
                Text(
                  period,
                  style: const TextStyle(color: Color(0x990F1633), fontSize: 11),
                ),
            ],
          ),
          if (desc.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 48),
              child: Text(
                desc,
                style: const TextStyle(color: Color(0x990F1633), fontSize: 12),
              ),
            ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFF0F1633), thickness: 0.5),
        ],
      ),
    );
  }

  void _navigateToEducationEdit(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEducationPage(
          initialEducation: _educationFromData(_profile?.educationLevel),
        ),
      ),
    );
    if (result != null && _profile != null) {
      setState(() {
        _profile = _profile!.copyWith(
          educationLevel: (result as List<EditEducation>).map((e) => {
            'degree': e.degree,
            'institution': e.institution,
            'year': e.year,
          }).toList(),
        );
      });
      _saveProfile();
    }
  }

  List<EditEducation> _educationFromData(dynamic data) {
    if (data == null || data is! List) return [];
    return data.map((e) => EditEducation(
      degree: e['degree']?.toString() ?? '',
      institution: e['institution']?.toString() ?? '',
      year: e['year']?.toString() ?? '',
    )).toList();
  }

  void _navigateToSkillsEdit(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSkillsPage(
          initialSkills: _skillsFromData(_profile?.skillsList),
        ),
      ),
    );
    if (result != null && _profile != null) {
      setState(() {
        _profile = _profile!.copyWith(
          skillsList: (result as List<EditSkill>).map((s) => {
            'name': s.name,
            'projectName': s.projectName,
            'workWith': s.workWith,
          }).toList(),
        );
      });
      _saveProfile();
    }
  }

  List<EditSkill> _skillsFromData(dynamic data) {
    if (data == null || data is! List) return [];
    return data.map((s) => EditSkill(
      name: s['name']?.toString() ?? '',
      projectName: s['projectName']?.toString() ?? '',
      workWith: s['workWith']?.toString() ?? '',
    )).toList();
  }

  void _navigateToProjectsEdit(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProjectsPage(
          initialProjects: _projectsFromData(_profile?.projects),
        ),
      ),
    );
    if (result != null && _profile != null) {
      setState(() {
        _profile = _profile!.copyWith(
          projects: (result as List<EditProject>).map((p) => {
            'name': p.name,
            'languages': p.languages,
            'tools': p.tools,
            'description': p.description,
            'githubUrl': p.githubUrl,
          }).toList(),
        );
      });
      _saveProfile();
    }
  }

  List<EditProject> _projectsFromData(dynamic data) {
    if (data == null || data is! List) return [];
    return data.map((p) => EditProject(
      name: p['name']?.toString() ?? '',
      languages: List<String>.from(p['languages'] ?? []),
      tools: List<String>.from(p['tools'] ?? []),
      description: p['description']?.toString() ?? '',
      githubUrl: p['githubUrl']?.toString() ?? '',
    )).toList();
  }

  void _navigateToExperienceEdit(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExperiencePage(
          initialExperience: _experienceFromData(_profile?.detailedExperience),
        ),
      ),
    );
    if (result != null && _profile != null) {
      setState(() {
        _profile = _profile!.copyWith(
          detailedExperience: (result as List<EditExperience>).map((exp) => {
            'company': exp.company,
            'role': exp.role,
            'period': exp.period,
            'description': exp.description,
          }).toList(),
        );
      });
      _saveProfile();
    }
  }

  List<EditExperience> _experienceFromData(dynamic data) {
    if (data == null || data is! List) return [];
    return data.map((exp) => EditExperience(
      company: exp['company']?.toString() ?? '',
      role: exp['role']?.toString() ?? '',
      period: exp['period']?.toString() ?? '',
      description: exp['description']?.toString() ?? '',
    )).toList();
  }

  Future<void> _saveProfile() async {
    if (_profile == null) return;
    try {
      await JobSeekerProfile.updateProfile(_profile!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      print('Save error: $e'); // Add for debugging
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
