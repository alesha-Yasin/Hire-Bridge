
import 'package:flutter/material.dart';
import 'package:hirebridge/screens/SplashScreen.dart';


class HireBridgeApp extends StatelessWidget {
  const HireBridgeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HireBridge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        primaryColor: const Color(0xFF0F1633),
      ),
      home: const SplashScreen(),
    );
  }
}