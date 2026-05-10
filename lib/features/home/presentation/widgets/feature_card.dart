import 'package:flutter/material.dart';
import 'package:growwise_mobile_app/features/home/presentation/widgets/home_colors.dart';
import 'package:growwise_mobile_app/services/t_text.dart';

class FeatureCard extends StatefulWidget {
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
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _pressed = false;
  bool _hovered = false;

  void _setPressed(bool value) {
    if (!mounted) return;
    setState(() => _pressed = value);
  }

  void _setHovered(bool value) {
    if (!mounted) return;
    setState(() => _hovered = value);
  }

  IconData _getFeatureIcon() {
    final text = widget.title.toLowerCase();

    if (text.contains("crop")) {
      return Icons.yard_rounded;
    }

    if (text.contains("care") || text.contains("plant")) {
      return Icons.local_florist_rounded;
    }

    if (text.contains("disease")) {
      return Icons.search_rounded;
    }

    return Icons.eco_rounded;
  }

  Color _getIconAccentColor() {
    final text = widget.title.toLowerCase();

    if (text.contains("disease")) {
      return const Color(0xFF38BDF8);
    }

    return const Color(0xFF16A34A);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF16212B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF2F4F3E) : const Color(0xFFBBF7D0);

    final titleColor = isDark ? Colors.white : kTextDark;
    final subtitleColor = isDark ? const Color(0xFF94A3B8) : kTextLight;
    final arrowColor = isDark ? const Color(0xFF94A3B8) : kTextLight;

    final iconAccent = _getIconAccentColor();
    final scale = _pressed ? 0.97 : (_hovered ? 1.015 : 1.0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) {
          _setPressed(false);
          widget.onTap();
        },
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: double.infinity,
            constraints: const BoxConstraints(
              minHeight: 88,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _hovered ? const Color(0xFF22C55E) : borderColor,
                width: _hovered ? 1.4 : 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(_hovered ? 0.34 : 0.25)
                      : Colors.black.withOpacity(_hovered ? 0.10 : 0.06),
                  blurRadius: _hovered ? 16 : 10,
                  offset: Offset(0, _hovered ? 7 : 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF22C55E),
                        Color(0xFF16A34A),
                        Color(0xFF0F766E),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F766E)
                            .withOpacity(_hovered ? 0.32 : 0.20),
                        blurRadius: _hovered ? 12 : 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        _getFeatureIcon(),
                        color: iconAccent,
                        size: 19,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TText(
                          widget.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.2,
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TText(
                          widget.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.8,
                            color: subtitleColor,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: _hovered
                          ? const Color(0xFFDCFCE7)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: _hovered
                          ? const Color(0xFF077530)
                          : arrowColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}