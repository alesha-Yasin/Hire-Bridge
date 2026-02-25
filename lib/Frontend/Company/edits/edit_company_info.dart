import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/Company/reusable_company_widgets.dart';
import 'package:hirebridge/models/Employer.dart';

class EditCompanyInfoPage extends StatefulWidget {
  final Employer employer;
  
  const EditCompanyInfoPage({super.key, required this.employer});

  @override
  State<EditCompanyInfoPage> createState() => _EditCompanyInfoPageState();
}

class _EditCompanyInfoPageState extends State<EditCompanyInfoPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _websiteController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employer.companyName);
    _descriptionController = TextEditingController(text: widget.employer.companyDescription ?? '');
    _addressController = TextEditingController(text: widget.employer.companyAddress ?? '');
    _websiteController = TextEditingController(text: widget.employer.companyWebsite ?? '');
    _emailController = TextEditingController(text: widget.employer.companyEmail ?? '');
    _phoneController = TextEditingController(text: widget.employer.companyPhone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    try {
      final updatedEmployer = widget.employer.copyWith(
        companyName: _nameController.text,
        companyDescription: _descriptionController.text,
        companyAddress: _addressController.text,
        companyWebsite: _websiteController.text,
        companyEmail: _emailController.text,
        companyPhone: _phoneController.text,
      );

      await Employer.updateEmployer(updatedEmployer);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Company information updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, updatedEmployer);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating company info: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E7EB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Company Info',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: const Text(
              'Save',
              style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CompanyCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CompanySectionTitle(title: 'Basic Information'),
                  const SizedBox(height: 20),
                  _buildTextField(
                    'Company Name',
                    _nameController,
                    Icons.business,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Description',
                    _descriptionController,
                    Icons.description,
                    maxLines: 5,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CompanyCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CompanySectionTitle(title: 'Contact Details'),
                  const SizedBox(height: 20),
                  _buildTextField(
                    'Address',
                    _addressController,
                    Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Website',
                    _websiteController,
                    Icons.language,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Email',
                    _emailController,
                    Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Phone',
                    _phoneController,
                    Icons.phone_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.cream.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(
            color: AppColors.cream,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.cream.withOpacity(0.6), size: 20),
            filled: true,
            fillColor: const Color(0xFF0F1633),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
