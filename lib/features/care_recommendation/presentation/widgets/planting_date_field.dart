import 'package:flutter/material.dart';

class PlantingDateField extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const PlantingDateField({
    super.key,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fillColor = isDark ? const Color(0xFF0F2234) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF6A86A0) : const Color(0xFFCFE1D5);
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final hintColor = isDark ? Colors.white54 : const Color(0xFF6B7280);
    final iconColor = isDark ? Colors.white70 : const Color(0xFF4B5563);

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: IgnorePointer(
        child: TextFormField(
          controller: TextEditingController(text: value),
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Select planting date',
            hintStyle: TextStyle(
              color: hintColor,
              fontSize: 15,
            ),
            filled: true,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            suffixIcon: Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: iconColor,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide(
                color: borderColor,
                width: 1.3,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: const BorderSide(
                color: Color(0xFF7ED957),
                width: 1.7,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        ),
      ),
    );
  }
}