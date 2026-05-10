import 'package:flutter/material.dart';
import 'package:growwise_mobile_app/services/t_text.dart';

class ProfileSectionTitle extends StatelessWidget {
  final String title;

  const ProfileSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: TText(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
          color: isDark
              ? const Color(0xFFF3F4F6)
              : const Color(0xFF374151),
        ),
      ),
    );
  }
}