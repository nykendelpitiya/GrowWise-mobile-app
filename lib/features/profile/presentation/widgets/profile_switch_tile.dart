import 'package:flutter/material.dart';
import 'package:growwise_mobile_app/services/t_text.dart';

class ProfileSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData lightIcon;
  final IconData darkIcon;

  const ProfileSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    required this.lightIcon,
    required this.darkIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final iconColor =
        isDark ? const Color(0xFF86EFAC) : const Color(0xFF4B5563);

    final titleColor =
        isDark ? Colors.white : const Color(0xFF111827);

    final cardBackground =
        isDark ? const Color(0xFF111827) : Colors.white;

    final borderColor =
        isDark ? const Color(0xFF355C44) : const Color(0xFFBBF7D0);

    final iconBackground =
        isDark ? const Color(0xFF1F2937) : const Color(0xFFF8FAFC);

    final switchTrackColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFA7F3D0);

    final currentIcon = value ? darkIcon : lightIcon;

    return Container(
      height: 70,
      margin: const EdgeInsets.only(bottom: 10),
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
              currentIcon,
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
                letterSpacing: 0.1,
                color: titleColor,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.92,
            child: Switch(
              value: value,
              materialTapTargetSize:
                  MaterialTapTargetSize.shrinkWrap,
              activeColor: const Color(0xFF077530),
              activeTrackColor: switchTrackColor,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}