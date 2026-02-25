import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/Company/reusable_company_widgets.dart';
import 'package:hirebridge/Frontend/Company/edits/edit_company_info.dart';
import 'package:hirebridge/models/Employer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({super.key});

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  bool _isLoading = true;
  Employer? _employer;
  int _selectedTabIndex = 0;

  final List<String> _tabs = ['Snapshot', 'Reviews', 'Jobs', 'Branches', 'Projects'];

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
        backgroundColor: Color(0xFFE5E7EB),
        body: Center(child: CircularProgressIndicator(color: AppColors.blue)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE5E7EB), // Light grey background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Company Profile',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF1F2937)),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),
            
            const SizedBox(height: 20),
            
            // Tab Navigation
            _buildTabNavigation(),
            
            const SizedBox(height: 20),
            
            // Tab Content
            _buildTabContent(),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CompanyCard(
        child: Column(
          children: [
            // Company Logo and Name
            Row(
              children: [
                // Logo
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    shape: BoxShape.circle,
                    image: _employer?.companyLogo != null
                        ? DecorationImage(
                            image: NetworkImage(_employer!.companyLogo!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _employer?.companyLogo == null
                      ? Center(
                          child: Text(
                            _employer?.companyName.substring(0, 1).toUpperCase() ?? 'C',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                // Name and Edit Icon
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _employer?.companyName ?? 'Company Name',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.cream,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditCompanyInfoPage(employer: _employer!),
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  _employer = result as Employer;
                                });
                              }
                            },
                            child: Icon(
                              Icons.edit,
                              color: AppColors.cream.withOpacity(0.7),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '4.2', // TODO: Get from reviews
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.cream.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            //  Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const CompanyStatItem(value: '12', label: 'Jobs Posted'),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.cream.withOpacity(0.3),
                ),
                const CompanyStatItem(value: '45', label: 'Employees'),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.cream.withOpacity(0.3),
                ),
                const CompanyStatItem(value: '28', label: 'Reviews'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabNavigation() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CompanyTabButton(
              label: _tabs[index],
              isSelected: _selectedTabIndex == index,
              onTap: () {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              badge: index == 2 ? '12' : null, // Jobs badge
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildSnapshotTab();
      case 1:
        return _buildReviewsTab();
      case 2:
        return _buildJobsTab();
      case 3:
        return _buildBranchesTab();
      case 4:
        return _buildProjectsTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSnapshotTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Info Cards
          CompanyCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CompanySectionTitle(title: 'About the Company'),
                const SizedBox(height: 16),
                Text(
                  _employer?.companyDescription ?? 'No description available.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: AppColors.cream.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Company Details
          CompanyCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CompanySectionTitle(title: 'Company Details'),
                const SizedBox(height: 16),
                if (_employer?.companyAddress != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CompanyInfoRow(
                      icon: Icons.location_on_outlined,
                      text: _employer!.companyAddress!,
                    ),
                  ),
                if (_employer?.companyWebsite != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CompanyInfoRow(
                      icon: Icons.language,
                      text: _employer!.companyWebsite!,
                    ),
                  ),
                if (_employer?.companyEmail != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CompanyInfoRow(
                      icon: Icons.email_outlined,
                      text: _employer!.companyEmail!,
                    ),
                  ),
                if (_employer?.companyPhone != null)
                  CompanyInfoRow(
                    icon: Icons.phone_outlined,
                    text: _employer!.companyPhone!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CompanyCard(
        child: CompanyEmptyState(
          icon: Icons.rate_review_outlined,
          title: 'No Reviews Yet',
          subtitle: 'Reviews from employees will appear here',
        ),
      ),
    );
  }

  Widget _buildJobsTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CompanyCard(
        child: CompanyEmptyState(
          icon: Icons.work_outline,
          title: 'No Jobs Posted',
          subtitle: 'Post your first job to attract talent',
          buttonText: 'Post a Job',
          onButtonTap: () {
            // Navigate to post job
          },
        ),
      ),
    );
  }

  Widget _buildBranchesTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CompanyCard(
        child: CompanyEmptyState(
          icon: Icons.business_outlined,
          title: 'No Branches Added',
          subtitle: 'Add company branches to showcase your locations',
          buttonText: 'Add Branch',
          onButtonTap: () {
            // Navigate to add branch
          },
        ),
      ),
    );
  }

  Widget _buildProjectsTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CompanyCard(
        child: CompanyEmptyState(
          icon: Icons.folder_outlined,
          title: 'No Projects Showcased',
          subtitle: 'Add completed projects to highlight your work',
          buttonText: 'Add Project',
          onButtonTap: () {
            // Navigate to add project
          },
        ),
      ),
    );
  }
}
