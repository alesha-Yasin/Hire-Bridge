import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/LoginPages/app_text_styles.dart';

class ProfileSectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const ProfileSectionCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(30),
      ),
      child: child,
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onEdit;
  final VoidCallback? onAdd;

  const SectionTitle({
    super.key,
    required this.title,
    this.onEdit,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyles.mainTitle.copyWith(
            color: AppColors.blue,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (onAdd != null)
          IconButton(
            onPressed: onAdd,
            icon: const Icon(Icons.add_circle_outline, color: AppColors.blue),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        if (onEdit != null)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit, color: AppColors.blue, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
      ],
    );
  }
}

class ProfileStatItem extends StatelessWidget {
  final String label;
  final String value;

  const ProfileStatItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
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
}

class ModernEditTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool readOnly;
  final int maxLines;

  const ModernEditTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.suffixIcon,
    this.onSuffixTap,
    this.readOnly = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            readOnly: readOnly,
            maxLines: maxLines,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.5),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.cream, width: 2),
              ),
              suffixIcon: suffixIcon != null
                  ? GestureDetector(
                      onTap: onSuffixTap,
                      child: Icon(suffixIcon, color: Colors.white),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class EditSectionHeader extends StatelessWidget {
  final String title;

  const EditSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class EditPageSaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const EditPageSaveButton({
    super.key,
    required this.onPressed,
    this.label = 'SAVE',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cream,
          foregroundColor: AppColors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

