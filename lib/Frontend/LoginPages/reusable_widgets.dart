import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';
import 'package:hirebridge/Frontend/LoginPages/app_text_styles.dart';




// ============================================
// FIGMA APP SCAFFOLD - Main layout matching Figma
// ============================================
class Decore extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onBack;
  final VoidCallback? onClose;

  const Decore({
    Key? key,
    required this.title,
    required this.child,
    this.onBack,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back, title, close
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: onBack ?? () => Navigator.pop(context),
                    child: const Icon(
                      Icons.chevron_left,
                      color: AppColors.blue,
                      size: 28,
                    ),
                  ),
                  Text(
                    title,
                    style: AppTextStyles.appBarTitle,
                  ),
                  GestureDetector(
                    onTap: onClose ?? () => Navigator.pop(context),
                    child: Image.asset(
                      'assets/images/Multiply.png',
                      width: 20,
                      height: 20,
                      color: AppColors.blue,
                    ),
                  ),
                ],
              ),
            ),
            // Building illustration area
            Expanded(
              flex: 2,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Building and trees illustration
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/images/trees.png',
                          height: 60,
                          color: AppColors.blue,
                        ),
                        Image.asset(
                          'assets/images/building.png',
                          height: 100,
                          color: AppColors.cream,
                        ),
                        Image.asset(
                          'assets/images/building.png',
                          height: 100,
                          color: AppColors.cream,
                        ),
                        Image.asset(
                          'assets/images/trees.png',
                          height: 60,
                          color: AppColors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Content area with rounded top corners
            Expanded(
              flex: 9,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// CUSTOM BUTTON (cream colored)
// ============================================
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 50,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.cream,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(25),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: AppTextStyles.buttonTexts.copyWith(
            color: textColor ?? AppColors.blue,
          ),
        ),
      ),
    );
  }
}

// ============================================
// SOCIAL LOGIN BUTTON (Google/Facebook)
// ============================================
class SocialLoginButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              text,
              style: AppTextStyles.verySmallHeading.copyWith(
                color: AppColors.blue,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// CIRCLE ICON BUTTON (Next/Back for intro)
// ============================================
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isTransparent;

  const CircleIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.isTransparent = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isTransparent ? AppColors.blue.withOpacity(0.2) : AppColors.background,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppColors.blue,
          size: 24,
        ),
      ),
    );
  }
}

// ============================================
// HIRE BRIDGE LOGO
// ============================================
class HireBridgeLogo extends StatelessWidget {
  final bool isSmall;
  final double width;

  const HireBridgeLogo({
    Key? key,
    this.isSmall = false,
    this.width = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      isSmall ? 'assets/images/logo_small.png' : 'assets/images/logo.png',
      width: width,
      fit: BoxFit.contain,
    );
  }
}

// ============================================
// ONBOARDING INDICATOR (Bars for intro)
// ============================================
class OnboardingIndicator extends StatelessWidget {
  final int total;
  final int current;

  const OnboardingIndicator({
    Key? key,
    required this.total,
    required this.current,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (index) {
        bool isActive = index == current;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 30,
          height: 3,
          decoration: BoxDecoration(
            color: isActive ? AppColors.blue : AppColors.background.withOpacity(0.5),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}

// ============================================
// CUSTOM TEXT FIELD with check icon
// ============================================
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool showCheckIcon;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.label = '',
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.showCheckIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: AppTextStyles.subheading,
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            style: const TextStyle(color: AppColors.blue),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: AppColors.cream.withOpacity(0.5)),
              prefixIcon: prefixIcon,
              suffixIcon: showCheckIcon
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.check_circle_outline,
                        color: AppColors.cream,
                        size: 20,
                      ),
                    )
                  : suffixIcon,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
// ============================================
// OTP INPUT BOX (dark blue background)
// ============================================
// class OtpInputBox extends StatelessWidget {
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String? value;

//   const OtpInputBox({
//     Key? key,
//     required this.controller,
//     required this.focusNode,
//     this.value,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 55,
//       height: 55,
//       decoration: BoxDecoration(
//         color: AppColors.darkBlue,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Center(
//         child: TextField(
//           controller: controller,
//           focusNode: focusNode,
//           textAlign: TextAlign.center,
//           keyboardType: TextInputType.number,
//           maxLength: 1,
//           style: AppTextStyles.otpNumber.copyWith(color: AppColors.parchment),
//           decoration: const InputDecoration(
//             counterText: '',
//             border: InputBorder.none,
//           ),
//           onChanged: (value) {
//             if (value.length == 1) {
//               FocusScope.of(context).nextFocus();
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// ============================================
// RESET OPTION CARD (for email/SMS selection)
// ============================================
class ResetOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const ResetOptionCard({/////////////////////////////////////////////////////////card with title,subtitle,icon  (EMAIL,SMS)
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.blue : AppColors.cream,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.blue,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.verySmallHeading,
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.verySmallText,
                  ),
                ],
              ),
            ),
            // Checkbox
            Container(//////////////////////////////////////////////////////  square box with check icon
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.blue: Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected ? AppColors.cream : AppColors.blue,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: AppColors.cream,
                      size: 16,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// CUSTOM NUMPAD (for OTP page)
// ============================================
class CustomNumpad extends StatelessWidget {
  final Function(String) onNumberTap;
  final VoidCallback onDelete;

  const CustomNumpad({
    Key? key,
    required this.onNumberTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1: 1, 2, 3
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumpadButton('1'),
            _buildNumpadButton('2'),
            _buildNumpadButton('3'),
          ],
        ),
        const SizedBox(height: 16),
        // Row 2: 4, 5, 6
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumpadButton('4'),
            _buildNumpadButton('5'),
            _buildNumpadButton('6'),
          ],
        ),
        const SizedBox(height: 16),
        // Row 3: 7, 8, 9
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumpadButton('7'),
            _buildNumpadButton('8'),
            _buildNumpadButton('9'),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 70),
            _buildNumpadButton('0'),
            const SizedBox(width: 70), 
          ],
        ),
      ],
    );
  }

  Widget _buildNumpadButton(String number) {
    return GestureDetector(
      onTap: () => onNumberTap(number),
      child: Container(
        width: 70,
        height: 50,
        alignment: Alignment.center,
        child: Text(
          number,
          style: AppTextStyles.numpadNumber,
        ),
      ),
    );
  }
}

// ============================================
// CONTACT OPTION CARD (legacy - keep for compatibility)        //otp 
// ============================================
// class ContactOptionCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final VoidCallback onTap;

//   const ContactOptionCard({
//     Key? key,
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: AppColors.cream,
//           borderRadius: BorderRadius.circular(30),
//           border: Border.all(color: AppColors.check),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: AppColors.cream.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(
//                 icon,
//                 color: AppColors.blue,
//                 size: 32,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: AppTextStyles.subheading,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     style: AppTextStyles.hintText,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//  //}

//  //}