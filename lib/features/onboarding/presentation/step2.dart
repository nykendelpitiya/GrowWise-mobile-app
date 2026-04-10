import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class Step2 extends StatefulWidget {
  const Step2({super.key});

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {
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

  Widget featureCard({
    required String iconPath,
    required String title,
    required String subtitle,
    required int delay,
  }) {
    return AnimatedSlide(
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOut,
      offset: animate ? Offset.zero : const Offset(0, 0.3),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 500 + delay),
        opacity: animate ? 1 : 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  iconPath,
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [

            /// 🔥 TOP SPACE
            const Spacer(flex: 1),

            /// 🔹 TITLE (CENTERED)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: animate ? 1 : 0,
              child: const Center(
                child: Text(
                  "Smart Farming Solutions",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// 🔹 CARDS GROUP (CENTERED)
            featureCard(
              iconPath: "assets/icons/crop.png",
              title: "Crop Recommendation",
              subtitle: "Get recommendations on what crops to plant.",
              delay: 0,
            ),

            const SizedBox(height: 16),

            featureCard(
              iconPath: "assets/icons/care.png",
              title: "Fertilizer & Water Schedule",
              subtitle: "Track and monitor plant growth.",
              delay: 150,
            ),

            const SizedBox(height: 16),

            featureCard(
              iconPath: "assets/icons/disease.png",
              title: "Disease Detection",
              subtitle: "Identify plant disease early.",
              delay: 300,
            ),

            /// 🔥 BOTTOM SPACE
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}