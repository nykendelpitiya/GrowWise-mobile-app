import 'package:flutter/material.dart';
import 'package:growwise_mobile_app/services/t_text.dart';

class LocationDropdownField extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  const LocationDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final fillColor = isDark
        ? const Color(0xFF0E1B2B)
        : const Color(0xFFF9FAFB);
    final dropdownBg = isDark ? const Color(0xFF102235) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF31506B)
        : const Color(0xFFDCE7DD);
    final focusedBorderColor = isDark
        ? const Color(0xFF4FA36A)
        : const Color(0xFF077530);
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final hintColor = isDark ? Colors.white54 : const Color(0xFF9CA3AF);
    final iconColor = isDark ? Colors.white70 : const Color(0xFF4B5563);

    return Theme(
      data: theme.copyWith(canvasColor: dropdownBg),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        menuMaxHeight: 320,
        borderRadius: BorderRadius.circular(24),
        icon: Icon(Icons.keyboard_arrow_down, color: iconColor, size: 24),
        dropdownColor: dropdownBg,
        style: TextStyle(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Choose district',
          hintStyle: TextStyle(
            color: hintColor,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: borderColor, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: focusedBorderColor, width: 1.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: borderColor, width: 1.2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: borderColor, width: 1.2),
          ),
        ),
        hint: TText(
          'Choose district',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: hintColor,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        selectedItemBuilder: (context) {
          return items.map((location) {
            return TText(
              location,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            );
          }).toList();
        },
        items: items.map((location) {
          return DropdownMenuItem<String>(
            value: location,
            child: TText(
              location,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}