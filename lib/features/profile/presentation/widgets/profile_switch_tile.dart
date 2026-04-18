import 'package:flutter/material.dart';

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
    final iconColor = isDark ? const Color(0xFF86EFAC) : const Color(0xFF4B5563);
    final titleColor = isDark ? Colors.white : const Color(0xFF111827);
    final cardBackground = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark ? const Color(0xFF355C44) : const Color(0xFFBBF7D0);
    final iconBackground = isDark ? const Color(0xFF1F2937) : const Color(0xFFF8FAFC);
    final switchTrackColor = isDark ? const Color(0xFF334155) : const Color(0xFFA7F3D0);

    final currentIcon = value ? darkIcon : lightIcon;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor,
          width: 1.2,
        ),
      ),
      child: ListTile(
        minLeadingWidth: 28,
        horizontalTitleGap: 12,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          currentIcon,
          color: iconColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: titleColor,
          ),
        ),
        trailing: Switch(
          value: value,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeColor: const Color(0xFF077530),
          activeTrackColor: switchTrackColor,
          onChanged: onChanged,
        ),
      ),
    );
  }
}