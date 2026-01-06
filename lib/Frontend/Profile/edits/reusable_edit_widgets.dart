import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';

class EditPageLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final VoidCallback onSave;
  final VoidCallback onAdd;
  final VoidCallback onClose;

  const EditPageLayout({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
    required this.onSave,
    required this.onAdd,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1633),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close, color: Colors.white70, size: 28),
                  ),
                  IconButton(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add_circle_outline, color: Colors.white70, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Title
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.cream,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 40),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
              const SizedBox(height: 30),
              // Content
              Expanded(
                child: ListView(
                  children: children,
                ),
              ),
              // Save Button
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cream,
                      foregroundColor: const Color(0xFF0F1633),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'SAVE',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onDelete;

  const EditCard({
    super.key,
    required this.child,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          child,
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

class EditInputField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final bool isLarge;

  const EditInputField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          onChanged: onChanged,
          maxLines: isLarge ? 10 : 1,
          style: const TextStyle(color: AppColors.cream),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.cream),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class EmptyStateHint extends StatelessWidget {
  final String message;
  final VoidCallback onAdd;

  const EmptyStateHint({
    super.key,
    required this.message,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Icon(Icons.add_circle_outline, color: Colors.white.withOpacity(0.2), size: 80),
          const SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 16),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white12,
              foregroundColor: AppColors.cream,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }
}
