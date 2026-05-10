import 'package:flutter/material.dart';
import 'package:growwise_mobile_app/services/t_text.dart';

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBackground =
        isDark ? const Color(0xFF111827) : Colors.white;

    final borderColor =
        isDark ? const Color(0xFF355C44) : const Color(0xFFBBF7D0);

    final titleColor =
        isDark ? Colors.white : const Color(0xFF111827);

    final iconColor =
        isDark ? const Color(0xFF86EFAC) : const Color(0xFF077530);

    final iconBackground =
        isDark ? const Color(0xFF1F2937) : const Color(0xFFECFDF3);

    final chevronColor =
        isDark ? const Color(0xFFCBD5E1) : const Color(0xFF9CA3AF);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 21,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TText(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: chevronColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}