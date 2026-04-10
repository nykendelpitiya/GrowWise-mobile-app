import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class Step3 extends StatefulWidget {
  const Step3({super.key});

  @override
  State<Step3> createState() => _Step3State();
}

class _Step3State extends State<Step3> {
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
    final screenHeight = MediaQuery.of(context).size.height;

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
                "assets/images/onboarding2.png",
                height: screenHeight * 0.25,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 30),

          
          AnimatedOpacity(
            duration: const Duration(milliseconds: 800),
            opacity: animate ? 1 : 0,
            child: const Text(
              "Start Your Smart Farming Journey🌱",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
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
              "Make better farming decisions with insights, automation, and guidance.",
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