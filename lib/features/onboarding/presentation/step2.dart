import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class Step2 extends StatefulWidget {
  const Step2({super.key});

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  bool animate = false;

  final List<Map<String, String>> features = const [
    {
      "title": "Crop Recommendation",
      "subtitle": "Find the most suitable crop for your district."
    },
    {
      "title": "Fertilizer & Water Recommendation",
      "subtitle": "Get clear fertilizer and watering guidance."
    },
    {
      "title": "Disease Detection",
      "subtitle": "Detect plant diseases early using image analysis."
    },
  ];

  final List<String> crops = const [
    "Tea",
    "Cinnamon",
    "Pepper",
    "Areca Nut",
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => animate = true);
    });
  }

  Widget featureItem({
    required String title,
    required String subtitle,
    required int delay,
  }) {
    return AnimatedSlide(
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic,
      offset: animate ? Offset.zero : const Offset(0, 0.2),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 500 + delay),
        opacity: animate ? 1 : 0,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                height: 23,
                width: 23,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15.2,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12.2,
                        color: AppColors.textSecondary,
                        height: 1.25,
                        fontWeight: FontWeight.w500,
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

  Widget cropItem({
    required String name,
    required int delay,
  }) {
    return AnimatedScale(
      duration: Duration(milliseconds: 450 + delay),
      scale: animate ? 1 : 0.85,
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 450 + delay),
        opacity: animate ? 1 : 0,
        child: Container(
          width: 120,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.18),
            ),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.spa_rounded,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(height: 5),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.2,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            
            AnimatedSlide(
              duration: const Duration(milliseconds: 550),
              curve: Curves.easeOutCubic,
              offset: animate ? Offset.zero : const Offset(0, 0.25),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 550),
                opacity: animate ? 1 : 0,
                child: const Center(
                  child: Column(
                    children: [
                      Text(
                        "Smart Farming Solutions",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Plan crops, care schedules, and plant health in one simple app.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            /// 🔹 FEATURES
            Column(
              children: List.generate(
                features.length,
                (index) => featureItem(
                  title: features[index]["title"]!,
                  subtitle: features[index]["subtitle"]!,
                  delay: index * 100,
                ),
              ),
            ),

            const SizedBox(height: 18),

            
            const Center(
              child: Text(
                "Supported Crops",
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: 12),

           
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                  crops.length,
                  (index) => cropItem(
                    name: crops[index],
                    delay: index * 90,
                  ),
                ),
              ),
            ),

            const Spacer(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}