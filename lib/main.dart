import 'package:flutter/material.dart';

import 'package:growwise_mobile_app/core/theme/app_theme.dart';
import 'package:growwise_mobile_app/features/splash/presentation/splash_screen.dart';

void main() {
  runApp(const GrowWiseApp());
}

class GrowWiseApp extends StatelessWidget {
  const GrowWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GrowWise',

      theme: AppTheme.lightTheme,

      
      home: const SplashScreen(),
    );
  }
}