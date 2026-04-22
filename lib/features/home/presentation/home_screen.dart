import 'package:flutter/material.dart';
import 'package:growwise_mobile_app/features/crop_recommendation/presentation/crop_recommendation_screen.dart';
import 'package:growwise_mobile_app/features/home/presentation/widgets/feature_card.dart';
import 'package:growwise_mobile_app/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:growwise_mobile_app/features/home/presentation/widgets/home_colors.dart';
import 'package:growwise_mobile_app/features/home/presentation/widgets/home_header.dart';
import 'package:growwise_mobile_app/features/home/presentation/widgets/today_tip_card.dart';
import 'package:growwise_mobile_app/features/home/presentation/widgets/weather_summary_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final screenBg = isDark ? const Color(0xFF071426) : Colors.white;
    final titleColor = isDark ? Colors.white : kTextDark;

    return Scaffold(
      backgroundColor: screenBg,
      bottomNavigationBar: const HomeBottomNav(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              const SizedBox(height: 12),

              const WeatherSummaryCard(),
              const SizedBox(height: 12),

              const TodayTipCard(),
              const SizedBox(height: 14),

              Text(
                "Main Features",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FeatureCard(
                      iconPath: "assets/icons/crop.png",
                      title: "Crop Recommendation",
                      subtitle: "Find the best crops for your location",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CropRecommendationScreen(),
                          ),
                        );
                      },
                    ),
                    FeatureCard(
                      iconPath: "assets/icons/care.png",
                      title: "Plant Care",
                      subtitle: "Water and fertilizer guidance",
                      onTap: () {},
                    ),
                    FeatureCard(
                      iconPath: "assets/icons/disease.png",
                      title: "Disease Detection",
                      subtitle: "Identify plant diseases early",
                      onTap: () {},
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
}