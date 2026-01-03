import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/LoginPages/app_text_styles.dart';

/// Selection Card Widget - Reusable for Job Seeker / Company cards
class SelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(18),
          border: isSelected
              ? Border.all(color: AppColors.cream, width: 3)
              : null,
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 55,
              height: 55,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.verySmallHeading.copyWith(
                      color: AppColors.cream,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.verySmallText.copyWith(
                      color: AppColors.cream,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Decorative circle with arrow icon
class DecorativeCircle extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final double size;

  const DecorativeCircle({
    super.key,
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
    this.size = 90,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          icon,
          color: iconColor,
          size: size * 0.4,
        ),
      ),
    );
  }
}

/// Back arrow button
class BackArrowButton extends StatelessWidget {
  final Color color;
  final VoidCallback? onTap;

  const BackArrowButton({
    super.key,
    this.color = AppColors.cream,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.pop(context),
      child: Icon(
        Icons.chevron_left,
        color: color,
        size: 32,
      ),
    );
  }
}

/// Rounded Rectangle Container for corner decorations
class RoundedRectDecoration extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  final bool roundTop; // if true, top is rounded; if false, bottom is rounded

  const RoundedRectDecoration({
    super.key,
    required this.color,
    this.width = 80,
    this.height = 140,
    this.roundTop = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: roundTop
            ? BorderRadius.only(
                topLeft: Radius.circular(width / 2),
                topRight: Radius.circular(width / 2),
              )
            : BorderRadius.only(
                bottomLeft: Radius.circular(width / 2),
                bottomRight: Radius.circular(width / 2),
              ),
      ),
    );
  }
}

/// Top-left corner decoration (blue circle overlapping grey rounded rect)
class TopLeftCornerDecoration extends StatelessWidget {
  const TopLeftCornerDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 180,
      child: Stack(
        children: [
          
          // Grey rounded rectangle (front, left)
          Positioned(
            top: 0,
            left: 0,
            child: RoundedRectDecoration(
              color: AppColors.background,
              width: 120,
              height: 170,
              roundTop: false,
            ),
          ),
          // Blue rounded rectangle (behind, right)
          Positioned(
            top: 0,
            right: 0,
            child: RoundedRectDecoration(
              color: AppColors.blue,
              width: 100,
              height: 120,
              roundTop: false,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom-right corner decoration (grey and blue rounded rects)
class BottomRightCornerDecoration extends StatelessWidget {
  const BottomRightCornerDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 180,
      child: Stack(
        children: [
          
          // Grey rounded rectangle (front, left)
          Positioned(
            bottom: 0,
            left: 0,
            child: RoundedRectDecoration(
              color: AppColors.background,
              width: 120,
              height: 170,
              roundTop: true,
            ),
          ),
          // Blue rounded rectangle (behind, right)
          Positioned(
            bottom: 0,
            right: 0,
            child: RoundedRectDecoration(
              color: AppColors.blue,
              width: 100,
              height: 120,
              roundTop: true,
            ),
          ),
        ],
      ),
    );
  }
}

/// Form Container - White with 50% opacity (semi-transparent)
class FormContainer extends StatelessWidget {
  final Widget child;

  const FormContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:  Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

/// Form Text Field with blue border
class FormTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;
  final bool readOnly;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;

  const FormTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.readOnly = false,
    this.keyboardType,
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
              color:  AppColors.cream.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppColors.blue, width: 2),
            ),
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              readOnly: readOnly,
              keyboardType: keyboardType,
              onTap: onTap,
              style: const TextStyle(color: AppColors.blue),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: AppColors.blue.withValues(alpha: 0.5)),
                prefixIcon: prefixIcon != null
                    ? Icon(prefixIcon, color: AppColors.blue, size: 20)
                    : null,
                suffixIcon: suffixIcon != null
                    ? Icon(suffixIcon, color: AppColors.blue, size: 20)
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
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

/// Form Dropdown with grey semi-transparent dropdown
class FormDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const FormDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
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
              color:  AppColors.cream.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppColors.blue, width: 2),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.blue),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                borderRadius: BorderRadius.circular(12),
                dropdownColor: AppColors.background.withValues(alpha: 0.9),
                style: const TextStyle(color: AppColors.blue, fontSize: 16),
                hint: Text(
                  'Select $label',
                  style: TextStyle(color: AppColors.blue.withValues(alpha: 0.5)),
                ),
                items: options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: const TextStyle(
                        color: AppColors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Scattered decoration images for background
class ScatteredDecorationImages extends StatelessWidget {
  const ScatteredDecorationImages({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Image 1 - top center (BLUE - monitor icon)
        Positioned(
          top: screenHeight * 0.14,
          left: screenWidth * 0.42,
          child: Image.asset(
            'assets/images/image05B.png',
            width: 50,
            opacity: const AlwaysStoppedAnimation(100),
          ),
        ),
        // Image 2 - top right (BLUE - clipboard)
        Positioned(
          top: screenHeight * 0.10,
          right: 15,
          child: Image.asset(
            'assets/images/image03blue.png',
            width: 60,
            opacity: const AlwaysStoppedAnimation(100),
          ),
        ),
        // Image 3 - left upper (GREY - document)
        Positioned(
          top: screenHeight * 0.18,
          left: -15,
          child: Image.asset(
            'assets/images/image06G.png',
            width: 60,
            opacity: const AlwaysStoppedAnimation(100),
          ),
        ),
        // Image 4 - right side upper (GREY - clipboard)
        Positioned(
          top: screenHeight * 0.28,
          right: -5,
          child: Image.asset(
            'assets/images/image05G.png',
            width: 45,
            opacity: const AlwaysStoppedAnimation(100),
          ),
        ),
        // Image 5 - left side middle (BLUE - large document)
        Positioned(
          top: screenHeight * 0.35,
          left: -10,
          child: Image.asset(
            'assets/images/image06G.png',
            width: 75,
            opacity: const AlwaysStoppedAnimation(100),
          ),
        ),
        // Image 6 - center (BLUE - clipboard with person)
        Positioned(
          top: screenHeight * 0.42,
          left: screenWidth * 0.38,
          child: Image.asset(
            'assets/images/image03blue.png',
            width: 70,
            opacity: const AlwaysStoppedAnimation(100),
          ),
        ),
        // Image 7 - right side (BLUE - monitor)
        Positioned(
          top: screenHeight * 0.38,
          right: 25,
          child: Image.asset(
            'assets/images/image05B.png',
            width: 55,
            opacity: const AlwaysStoppedAnimation(100),
          ),
        ),
        // Image 8 - left lower (GREY - document)
        Positioned(
          top: screenHeight * 0.52,
          left: 15,
          child: Image.asset(
            'assets/images/image06G.png',
            width: 50,
            opacity: const AlwaysStoppedAnimation(100),
          ),
        ),
        // Image 9 - right lower (GREY - clipboard)
        Positioned(
          top: screenHeight * 0.50,
          right: 10,
          child: Image.asset(
            'assets/images/image05G.png',
            width: 50,
            opacity: const AlwaysStoppedAnimation(100),
          ),
        ),
        // Image 10 - center lower (BLUE - monitor)
        Positioned(
          top: screenHeight * 0.58,
          left: screenWidth * 0.45,
          child: Image.asset(
            'assets/images/image05B.png',
            width: 50,
            opacity: const AlwaysStoppedAnimation(100),
          ),
        ),
        // Image 11 - bottom left area (GREY)
        Positioned(
          bottom: screenHeight * 0.25,
          left: -10,
          child: Image.asset(
            'assets/images/image06G.png',
            width: 50,
            opacity: const AlwaysStoppedAnimation(100),
          ),
        ),
        // Image 12 - bottom right area (BLUE)
        Positioned(
          bottom: screenHeight * 0.28,
          right: screenWidth * 0.35,
          child: Image.asset(
            'assets/images/image03blue.png',
            width: 50,
            opacity: const AlwaysStoppedAnimation(100),
          ),
        ),
      ],
    );
  }
}

/// Searchable and Editable Dropdown
class SearchableFormDropdown extends StatefulWidget {
  final String label;
  final String? value;
  final List<String> options;
  final ValueChanged<String> onSelected;
  final String? hintText;

  const SearchableFormDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onSelected,
    this.hintText,
  });

  @override
  State<SearchableFormDropdown> createState() => _SearchableFormDropdownState();
}

class _SearchableFormDropdownState extends State<SearchableFormDropdown> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value ?? '';
  }

  @override
  void didUpdateWidget(SearchableFormDropdown oldWidget) {
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
                      border: Border.all(color: AppColors.blue, width: 2),
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

