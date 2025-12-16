import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double height;
  final bool isSmall;

  const AppLogo({
    Key? key,
    this.height = 40,
    this.isSmall = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      isSmall ? 'assets/images/logo_small.png' : 'assets/images/splash_logo.png',
      height: height,
      fit: BoxFit.contain,
    );
  }
}