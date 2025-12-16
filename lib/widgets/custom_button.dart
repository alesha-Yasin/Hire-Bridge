
import 'package:flutter/material.dart';
import 'package:hirebridge/utils/AppColors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final Color? backgroundColor;
  final Color iconColor;
  final double size;

  const CustomButton({
    super.key,
    this.onTap,
    required this.icon,
    this.backgroundColor,
    this.iconColor = AppColors.prussianBlue,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: backgroundColor ?? AppColors.silver.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 28,
        ),
      ),
    );
  }
}