import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class Step2 extends StatefulWidget {
  const Step2({super.key});

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  bool animate = false;

  final List<Map<String, dynamic>> features = const [
    {
      "icon": Icons.psychology_rounded,
      "title": "AI Crop Recommendation",
      "subtitle": "Find the best crop using smart AI insights."
    },
    {
      "icon": Icons.water_drop_rounded,
      "title": "Smart Care Guidance",
      "subtitle": "Get fertilizer and watering plans."
    },
    {
      "icon": Icons.health_and_safety_rounded,
      "title": "AI Disease Detection",
      "subtitle": "Detect plant diseases using image analysis."
    },
  ];

  final List<Map<String, dynamic>> crops = const [
    {
      "name": "Tea",
      "icon": Icons.local_florist_rounded,
    },
    {
      "name": "Cinnamon",
      "icon": Icons.eco_rounded,
    },
    {
      "name": "Pepper",
      "icon": Icons.grass_rounded,
    },
    {
      "name": "Areca Nut",
      "icon": Icons.spa_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => animate = true);
    });
  }

  Widget featureItem({
    required IconData icon,
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
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF22C55E),
                        Color(0xFF077530),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.18),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13.8,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.2,
                          color: AppColors.textSecondary,
                          height: 1.2,
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
      ),
    );
  }

  Widget cropItem({
    required String name,
    required IconData icon,
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
          width: 116,
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFF7FFF9),
                Color(0xFFE2F7E8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.18),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget aiBadge() {
    return AnimatedScale(
      duration: const Duration(milliseconds: 550),
      scale: animate ? 1 : 0.9,
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 550),
        opacity: animate ? 1 : 0,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7EE),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.18),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 14,
                  color: AppColors.primary,
                ),
                SizedBox(width: 6),
                Text(
                  "AI Powered Agriculture",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            aiBadge(),
            const SizedBox(height: 10),
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
                        "AI-Powered Smart Farming",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Get AI-based crop recommendations, disease detection, and smart plant care guidance.",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.7,
                          color: AppColors.textSecondary,
                          height: 1.32,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 13),
            Column(
              children: List.generate(
                features.length,
                (index) => featureItem(
                  icon: features[index]["icon"] as IconData,
                  title: features[index]["title"] as String,
                  subtitle: features[index]["subtitle"] as String,
                  delay: index * 90,
                ),
              ),
            ),
            const SizedBox(height: 11),
            const Center(
              child: Text(
                "Supported Crops",
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  crops.length,
                  (index) => cropItem(
                    name: crops[index]["name"] as String,
                    icon: crops[index]["icon"] as IconData,
                    delay: index * 80,
                  ),
                ),
              ),
            ),
            const Spacer(flex: 1),
            const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }
}