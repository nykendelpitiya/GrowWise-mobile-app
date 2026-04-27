import 'package:flutter/material.dart';
import 'package:growwise_mobile_app/features/home/presentation/widgets/home_colors.dart';

class FeatureCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF16212B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF2F4F3E) : const Color(0xFFBBF7D0);
    final iconBgColor =
        isDark ? const Color(0xFF1F3A2C) : const Color(0xFFDCFCE7);
    final titleColor = isDark ? Colors.white : kTextDark;
    final subtitleColor =
        isDark ? const Color(0xFF94A3B8) : kTextLight;
    final arrowColor =
        isDark ? const Color(0xFF94A3B8) : kTextLight;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: borderColor,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(
                      iconPath,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: subtitleColor,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: arrowColor,
            ),
          ],
        ),
      ),
    );
  }
}