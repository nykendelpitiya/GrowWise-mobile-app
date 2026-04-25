import 'package:flutter/material.dart';

class QuantityInputField extends StatelessWidget {
  final TextEditingController controller;

  const QuantityInputField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fillColor = isDark ? const Color(0xFF0F2234) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF6A86A0) : const Color(0xFFCFE1D5);
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final hintColor = isDark ? Colors.white54 : const Color(0xFF6B7280);

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(
        color: textColor,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: 'Enter quantity',
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
    );
  }
}