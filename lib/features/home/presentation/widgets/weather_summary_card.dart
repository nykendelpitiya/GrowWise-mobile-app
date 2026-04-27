import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class WeatherSummaryCard extends StatefulWidget {
  final String city;

  const WeatherSummaryCard({super.key, required this.city});

  @override
  State<WeatherSummaryCard> createState() => _WeatherSummaryCardState();
}

class _WeatherSummaryCardState extends State<WeatherSummaryCard> {
  Map<String, dynamic>? weatherData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  void didUpdateWidget(covariant WeatherSummaryCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.city != widget.city) {
      fetchWeather();
    }
  }

  Future<void> fetchWeather() async {
    if (!mounted) return;

    setState(() => isLoading = true);

    try {
      final res = await Dio().get(
        "http://localhost:8000/weather",
        queryParameters: {"district": widget.city},
      );

      if (mounted) {
        setState(() {
          weatherData = res.data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          weatherData = null;
          isLoading = false;
        });
      }
    }
  }

  IconData getWeatherIcon(String condition) {
    final value = condition.toLowerCase();

    if (value.contains("rain")) return Icons.water_drop_rounded;
    if (value.contains("cloud")) return Icons.cloud_rounded;
    if (value.contains("clear")) return Icons.wb_sunny_rounded;
    if (value.contains("storm") || value.contains("thunder")) {
      return Icons.thunderstorm_rounded;
    }

    return Icons.wb_cloudy_rounded;
  }

  String getConditionText(String condition) {
    final value = condition.toLowerCase();

    if (value.contains("rain")) return "Rainy weather";
    if (value.contains("cloud")) return "Cloudy weather";
    if (value.contains("clear")) return "Clear sky";
    if (value.contains("storm") || value.contains("thunder")) {
      return "Stormy weather";
    }

    return condition;
  }

  List<Color> getWeatherGradient(String condition) {
    final value = condition.toLowerCase();

    if (value.contains("rain")) {
      return const [Color(0xFF2563EB), Color(0xFF0F766E)];
    } else if (value.contains("cloud")) {
      return const [Color(0xFF22C55E), Color(0xFF0F766E)];
    } else if (value.contains("clear")) {
      return const [Color(0xFFF59E0B), Color(0xFF16A34A)];
    } else if (value.contains("storm") || value.contains("thunder")) {
      return const [Color(0xFF374151), Color(0xFF065F46)];
    } else {
      return const [Color(0xFF22C55E), Color(0xFF077530)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final tempText = weatherData?["temperature"]?.toString() ?? "--";
    final condition = weatherData?["condition"]?.toString() ?? "Unavailable";
    final humidity = weatherData?["humidity"]?.toString() ?? "--";
    final ph = weatherData?["ph"]?.toString() ?? "--";

    final double tempValue =
        double.tryParse(weatherData?["temperature"]?.toString() ?? "") ?? 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 124,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: getWeatherGradient(condition),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: getWeatherGradient(condition).last.withOpacity(0.22),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: isLoading
          ? const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "${widget.city}, Sri Lanka",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: tempValue),
                            duration: const Duration(milliseconds: 900),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return Text(
                                tempText == "--"
                                    ? "--°C"
                                    : "${value.toStringAsFixed(1)}°C",
                                style: const TextStyle(
                                  fontSize: 31,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.22),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              getWeatherIcon(condition),
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        getConditionText(condition),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: 82,
                      height: 86,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _miniInfoRow(
                            icon: Icons.water_drop_rounded,
                            value: "$humidity%",
                          ),
                          Container(
                            height: 1,
                            width: 48,
                            color: Colors.white.withOpacity(0.25),
                          ),
                          _miniInfoRow(
                            icon: Icons.eco_rounded,
                            value: "pH $ph",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _miniInfoRow({
    required IconData icon,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 15,
        ),
        const SizedBox(width: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}