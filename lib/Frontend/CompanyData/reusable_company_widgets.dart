import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/LoginPages/app_text_styles.dart';

/// Student Profile Form Container - White with 50% opacity
class CompanyFormContainer extends StatelessWidget {
  final Widget child;

  const CompanyFormContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

/// Student Form Text Field
class CompanyFormField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final IconData? suffixIcon;
  final bool readOnly;
  final int maxLines;
  final VoidCallback? onTap;

  const CompanyFormField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.suffixIcon,
    this.readOnly = false,
    this.maxLines = 1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.verySmallHeading.copyWith(
              color: AppColors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cream.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(maxLines > 1 ? 12 : 25),
              border: Border.all(color: AppColors.blue, width: 1.5),
            ),
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              maxLines: maxLines,
              onTap: onTap,
              style: const TextStyle(color: AppColors.blue),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: AppColors.blue.withValues(alpha: 0.5)),
                suffixIcon: suffixIcon != null
                    ? Icon(suffixIcon, color: AppColors.blue, size: 20)
                    : null,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: maxLines > 1 ? 12 : 10,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Searchable and Editable Student Dropdown
class SearchableCompanyDropdown extends StatefulWidget {
  final String label;
  final String? value;
  final List<String> options;
  final ValueChanged<String> onSelected;
  final String? hintText;

  const SearchableCompanyDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onSelected,
    this.hintText,
  });

  @override
  State<SearchableCompanyDropdown> createState() => _SearchableCompanyDropdownState();
}

class _SearchableCompanyDropdownState extends State<SearchableCompanyDropdown> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value ?? '';
  }

  @override
  void didUpdateWidget(SearchableCompanyDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: AppTextStyles.verySmallHeading.copyWith(
              color: AppColors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          LayoutBuilder(
            builder: (context, constraints) {
              return RawAutocomplete<String>(
                textEditingController: _controller,
                focusNode: _focusNode,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return widget.options;
                  }
                  return widget.options.where((String option) {
                    return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  widget.onSelected(selection);
                },
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.cream.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: AppColors.blue, width: 1.5),
                    ),
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: widget.hintText ?? 'Select or Type ${widget.label}',
                        hintStyle: TextStyle(color: AppColors.blue.withValues(alpha: 0.5)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: InputBorder.none,
                        suffixIcon: const Icon(Icons.keyboard_arrow_down, color: AppColors.blue),
                      ),
                      onChanged: (val) {
                         widget.onSelected(val);
                      },
                    ),
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.background.withValues(alpha: 0.95),
                      child: Container(
                        width: constraints.maxWidth,
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return InkWell(
                              onTap: () => onSelected(option),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Text(
                                  option,
                                  style: const TextStyle(
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Scattered Student Images for background
class ScatteredCompanyImages extends StatelessWidget {
  const ScatteredCompanyImages({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Center icons - 4 images in 2x2 grid
        Positioned(
          top: screenHeight * 0.40,
          left: screenWidth * 0.22,
          child: Row(
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/images/imageCB2.png',
                    width: 90,
                    opacity: const AlwaysStoppedAnimation(100),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    'assets/images/imageCG2.png',
                    width: 90,
                    opacity: const AlwaysStoppedAnimation(100),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  Image.asset(
                    'assets/images/imageCG1.png',
                    width: 90,
                    opacity: const AlwaysStoppedAnimation(100),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    'assets/images/imageCB1.png',
                    width: 90,
                    opacity: const AlwaysStoppedAnimation(100),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Profile Photo Upload Widget
class ProfilePhotoUpload extends StatelessWidget {
  final VoidCallback onTap;

  const ProfilePhotoUpload({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Blue container with "PROFILE PHOTO" text
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'PROFILE PHOTO',
            style: AppTextStyles.buttonTexts.copyWith(
              color: AppColors.cream,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        // Circular photo placeholder
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.6),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blue.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 80,
                  color: AppColors.blue.withValues(alpha: 0.3),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Upload button
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              'UPLOAD',
              style: AppTextStyles.buttonTexts.copyWith(
                color: AppColors.cream,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Page Indicator Dots
class PageIndicatorDots extends StatelessWidget {
  final int totalPages;
  final int currentPage;

  const PageIndicatorDots({
    super.key,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalPages, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index ? AppColors.blue : Colors.transparent,
            border: Border.all(color: AppColors.blue, width: 2),
          ),
        );
      }),
    );
  }
}

/// Verification Status Selector with Radio Buttons
class VerificationStatusSelector extends StatelessWidget {
  final String? selectedStatus;
  final ValueChanged<String?> onChanged;

  const VerificationStatusSelector({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verification Status',
          style: AppTextStyles.verySmallHeading.copyWith(
            color: AppColors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'you cannot make account without Verification of company',
          style: TextStyle(
            color: Colors.red.shade800,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildRadioButton('Verified'),
        _buildRadioButton('Pending'),
        _buildRadioButton('Rejected'),
      ],
    );
  }

  Widget _buildRadioButton(String status) {
    return InkWell(
      onTap: () => onChanged(status),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.blue, width: 2),
              ),
              child: Center(
                child: selectedStatus == status
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.blue,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              status,
              style: const TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

