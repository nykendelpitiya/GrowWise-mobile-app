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
    final isRain = alert.toLowerCase() == "rain";

    final gradientColors = isRain
        ? const [
            Color(0xFFFFF1F2),
            Color(0xFFFFE4E6),
          ]
        : const [
            Color(0xFFFFF7ED),
            Color(0xFFFFEDD5),
          ];

    final borderColor = isRain
        ? const Color(0xFFFCA5A5)
        : const Color(0xFFFDBA74);

    final titleColor = isRain
        ? const Color(0xFF991B1B)
        : const Color(0xFF9A3412);

    final textColor = isRain
        ? const Color(0xFF7F1D1D)
        : const Color(0xFF7C2D12);

    final iconColor =
        isRain ? const Color(0xFFEF4444) : const Color(0xFFF97316);

    final icon =
        isRain ? Icons.warning_amber_rounded : Icons.lightbulb_rounded;

    return Container(
      width: double.infinity,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRain ? "Weather Alert" : title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
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
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isRain ? "Alert" : "Tip",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}