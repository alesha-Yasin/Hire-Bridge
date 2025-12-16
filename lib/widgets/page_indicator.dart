import 'package:flutter/material.dart';
import 'package:hirebridge/utils/AppColors.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: currentPage == index ? 40 : 12,
          height: 12,
          decoration: BoxDecoration(
            color: currentPage == index
                ? AppColors.prussianBlue
                // ignore: deprecated_member_use
                : AppColors.silver.withOpacity(0.5),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}
