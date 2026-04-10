import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class Step1 extends StatefulWidget {
  const Step1({super.key});

  @override
  State<Step1> createState() => _Step1State();
}

class _Step1State extends State<Step1> {
  bool animate = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        animate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          
          AnimatedSlide(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            offset: animate ? Offset.zero : const Offset(0, 0.3),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: animate ? 1 : 0,
              child: Image.asset(
                "assets/images/onboarding1.png", //
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 30),

         
          AnimatedOpacity(
            duration: const Duration(milliseconds: 800),
            opacity: animate ? 1 : 0,
            child: const Text(
              "Welcome to GrowWise",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary, 
              ),
            ),
          ),

          const SizedBox(height: 12),

          AnimatedOpacity(
            duration: const Duration(milliseconds: 1000),
            opacity: animate ? 1 : 0,
            child: const Text(
              "Smart farming starts here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}