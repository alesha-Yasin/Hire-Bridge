import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/CompanyData/company_data_page.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/LoginPages/app_text_styles.dart';
import 'package:hirebridge/Frontend/UserData/reusable_data_widgets.dart';
import 'package:hirebridge/Frontend/JobseekerData/Jobseeker_data_page.dart';
import 'package:hirebridge/models/User.dart' as model;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';


class UserDetailsPage extends StatefulWidget {
  final String userType;

  const UserDetailsPage({
    super.key,
    required this.userType,
  });

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  // Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _createdDateController = TextEditingController();
  final TextEditingController _accountTypeController = TextEditingController();

  String? _selectedGender;
  String? _selectedCity;
  String? _selectedCountry;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _createdDateController.text =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    _accountTypeController.text = widget.userType == 'job_seeker' ? 'Job Seeker' : 'Employer';
  }

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _createdDateController.dispose();
    _accountTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          // Scattered decoration images
          const ScatteredDecorationImages(),

          // Top-left corner decoration
          const Positioned(
            top: 0,
            left: 0,
            child: TopLeftCornerDecoration(),
          ),

          // Bottom-right corner decoration
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

                // Title "Enter Your Details:"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Enter Your Details:',
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
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == 0
                                  ? AppColors.blue
                                  : Colors.transparent,
                              border: Border.all(color: AppColors.blue, width: 2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == 1
                                  ? AppColors.blue
                                  : Colors.transparent,
                              border: Border.all(color: AppColors.blue, width: 2),
                            ),
                          ),
                        ],
                      ),

                      // NEXT button
                      GestureDetector(
                        onTap: () {
                          if (_currentPage < 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            // Submit
                            _submitForm();
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

  Widget _buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FormContainer(
        child: Column(
          children: [
            FormTextField(
              label: 'First Name',
              controller: _firstNameController,
            ),
            FormTextField(
              label: 'Last Name',
              controller: _lastNameController,
            ),
            FormTextField(
              label: 'Address',
              controller: _addressController,
            ),
            FormTextField(
              label: 'Account Type',
              controller: _accountTypeController,
              readOnly: true,
            ),
            FormTextField(
              label: 'Phone',
              controller: _phoneController,
              hintText: '+92 3*********',
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            FormTextField(
              label: 'Date Of Birth',
              controller: _dobController,
              hintText: 'DD/MM/YYYY',
              suffixIcon: Icons.calendar_today_outlined,
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  _dobController.text =
                      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FormContainer(
        child: Column(
          children: [
            SearchableFormDropdown(
              label: 'Gender',
              value: _selectedGender,
              options: const ['Female', 'Male', 'Other'],
              onSelected: (val) => setState(() => _selectedGender = val),
            ),
            SearchableFormDropdown(
              label: 'City',
              value: _selectedCity,
              options: const [
                'Karachi',
                'Lahore',
                'Islamabad',
                'Faisalabad',
                'Rawalpindi',
                'Multan',
                'Gujranwala',
                'Peshawar',
                'Quetta',
                'Sialkot',
                'Bahawalpur',
                'Sukkur',
                'Jhang',
                'Sheikhupura',
                'Larkana'
              ],
              onSelected: (val) => setState(() => _selectedCity = val),
            ),
            SearchableFormDropdown(
              label: 'Country',
              value: _selectedCountry,
              options: const [
                'Pakistan',
                'USA',
                'UK',
                'Canada',
                'Australia',
                'UAE',
                'Saudi Arabia',
                'Germany',
                'France',
                'China',
                'Japan',
                'Turkey',
                'Malaysia',
                'Singapore'
              ],
              onSelected: (val) => setState(() => _selectedCountry = val),
            ),
            FormTextField(
              label: 'Created Date',
              controller: _createdDateController,
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    final supabaseUser = Supabase.instance.client.auth.currentUser;
    if (supabaseUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      DateTime? dob;
      if (_dobController.text.isNotEmpty) {
        dob = DateFormat('dd/MM/yyyy').parse(_dobController.text);
      }

      final user = model.User(
        userId: supabaseUser.id,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        gender: _selectedGender,
        dateOfBirth: dob,
        phone: _phoneController.text,
        city: _selectedCity,
        country: _selectedCountry,
        address: _addressController.text,
        accountType: widget.userType == 'job_seeker' ? 'Job Seeker' : 'Employer',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await model.User.createUser(user);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Details Saved!'),
            backgroundColor: AppColors.greenSuccess,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );

        // Navigate based on user type
        if (widget.userType == 'job_seeker') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const JobseekerDataPage(),
            ),
          );
        } else if (widget.userType == 'company') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CompanyDataPage(),
            ),
          );
        } else {
          // Fallback
          Navigator.popUntil(context, (route) => route.isFirst);
        }
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
