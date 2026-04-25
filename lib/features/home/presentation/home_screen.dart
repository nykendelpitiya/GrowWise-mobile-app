import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:growwise_mobile_app/features/care_recommendation/presentation/care_input_screen.dart';
import 'package:growwise_mobile_app/features/crop_recommendation/presentation/crop_recommendation_screen.dart';
import 'package:growwise_mobile_app/features/home/presentation/widgets/feature_card.dart';
import 'package:growwise_mobile_app/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:growwise_mobile_app/features/home/presentation/widgets/home_colors.dart';
import 'package:growwise_mobile_app/features/home/presentation/widgets/home_header.dart';
import 'package:growwise_mobile_app/features/home/presentation/widgets/today_tip_card.dart';
import 'package:growwise_mobile_app/features/home/presentation/widgets/weather_summary_card.dart';
import 'package:growwise_mobile_app/services/today_tip_api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, dynamic>?>? _todayTipFuture;

  String _city = "Kandy";
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();

    _loadUserDistrictAndTip();

    _refreshTimer = Timer.periodic(
      const Duration(minutes: 10),
      (_) => _refreshTip(),
    );
  }

  Future<void> _loadUserDistrictAndTip() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        _setCityAndLoadTip("Kandy");
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      final data = doc.data();

      final userDistrict =
          data?["district"]?.toString().trim().isNotEmpty == true
              ? data!["district"].toString().trim()
              : data?["location"]?.toString().trim().isNotEmpty == true
                  ? data!["location"].toString().trim()
                  : data?["city"]?.toString().trim().isNotEmpty == true
                      ? data!["city"].toString().trim()
                      : "Kandy";

      _setCityAndLoadTip(userDistrict);
    } catch (_) {
      _setCityAndLoadTip("Kandy");
    }
  }

  void _setCityAndLoadTip(String city) {
    if (!mounted) return;

    setState(() {
      _city = city;
      _todayTipFuture = TodayTipApiService.getTodayTip(_city);
    });

    debugPrint("📍 Today Tip City: $_city");
  }

  Future<void> _refreshTip() async {
    if (!mounted) return;

    setState(() {
      _todayTipFuture = TodayTipApiService.getTodayTip(_city);
    });

    debugPrint("🔄 Today Tip Refreshed: $_city");
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screenBg = isDark ? const Color(0xFF071426) : Colors.white;
    final titleColor = isDark ? Colors.white : kTextDark;
    final loaderBg = isDark ? const Color(0xFF16212B) : const Color(0xFFFFF8E8);

    return Scaffold(
      backgroundColor: screenBg,
      bottomNavigationBar: const HomeBottomNav(),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF077530),
          onRefresh: _refreshTip,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeHeader(),
                  const SizedBox(height: 12),

                  const WeatherSummaryCard(),
                  const SizedBox(height: 12),

                  _todayTipFuture == null
                      ? Container(
                          width: double.infinity,
                          height: 76,
                          decoration: BoxDecoration(
                            color: loaderBg,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Color(0xFF077530),
                              ),
                            ),
                          ),
                        )
                      : FutureBuilder<Map<String, dynamic>?>(
                          future: _todayTipFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                width: double.infinity,
                                height: 76,
                                decoration: BoxDecoration(
                                  color: loaderBg,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Color(0xFF077530),
                                    ),
                                  ),
                                ),
                              );
                            }

                            if (snapshot.hasError || snapshot.data == null) {
                              return const TodayTipCard(
                                title: 'Today Tip',
                                message:
                                    'Keep monitoring your plants daily and adjust care based on weather conditions.',
                                alert: 'normal',
                              );
                            }

                            final data = snapshot.data!;

                            return TodayTipCard(
                              title: data['title']?.toString() ?? 'Today Tip',
                              message: data['message']?.toString() ??
                                  'Keep monitoring your plants daily.',
                              alert: data['alert']?.toString() ?? 'normal',
                            );
                          },
                        ),

                  const SizedBox(height: 14),

                  Text(
                    "Main Features",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Column(
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
                      const SizedBox(height: 12),
                      FeatureCard(
                        iconPath: "assets/icons/care.png",
                        title: "Plant Care",
                        subtitle: "Water and fertilizer guidance",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CareInputScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      FeatureCard(
                        iconPath: "assets/icons/disease.png",
                        title: "Disease Detection",
                        subtitle: "Identify plant diseases early",
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}