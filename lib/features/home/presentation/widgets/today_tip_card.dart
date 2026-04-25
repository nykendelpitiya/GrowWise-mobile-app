import 'package:flutter/material.dart';

class TodayTipCard extends StatelessWidget {
  final String title;
  final String message;
  final String alert;

  const TodayTipCard({
    super.key,
    required this.title,
    required this.message,
    this.alert = "normal",
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRain = alert.toLowerCase() == "rain";

    final bgColor = isRain
        ? (isDark ? const Color(0xFF3B1F1F) : const Color(0xFFFFEBEE))
        : (isDark ? const Color(0xFF2A1F14) : const Color(0xFFFFF7ED));

    final borderColor = isRain
        ? (isDark ? const Color(0xFFEF4444) : const Color(0xFFFCA5A5))
        : (isDark ? const Color(0xFF8B5A2B) : const Color(0xFFFDBA74));

    final titleColor = isRain
        ? (isDark ? const Color(0xFFFECACA) : const Color(0xFF991B1B))
        : (isDark ? const Color(0xFFFFD8A8) : const Color(0xFF9A3412));

    final textColor = isRain
        ? (isDark ? const Color(0xFFFEE2E2) : const Color(0xFF7F1D1D))
        : (isDark ? const Color(0xFFFDE68A) : const Color(0xFF7C2D12));

    final iconColor =
        isRain ? const Color(0xFFEF4444) : const Color(0xFFF97316);

    final icon =
        isRain ? Icons.warning_amber_rounded : Icons.lightbulb_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRain ? "Weather Alert" : title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}