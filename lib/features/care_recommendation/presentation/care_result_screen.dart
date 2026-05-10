import 'package:flutter/material.dart';
import 'package:growwise_mobile_app/services/t_text.dart';

class CareResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const CareResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screenBg = isDark ? const Color(0xFF0B1622) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtitleColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563);

    final highlightBg =
        isDark ? const Color(0xFF1F3D2B) : const Color(0xFFDFF5E5);
    final highlightBorder =
        isDark ? const Color(0xFF2F6B46) : const Color(0xFF9ED8B5);

    final cardBg = isDark ? const Color(0xFF16212B) : Colors.white;
    final cardBorder =
        isDark ? const Color(0xFF2E4153) : const Color(0xFFE5E7EB);

    final noteBg = isDark ? const Color(0xFF3A2515) : const Color(0xFFFFF7ED);
    final noteBorder =
        isDark ? const Color(0xFF8B5A2B) : const Color(0xFFFDBA74);
    final noteTitleColor =
        isDark ? const Color(0xFFFFD8A8) : const Color(0xFF9A3412);
    final noteTextColor =
        isDark ? const Color(0xFFFDE68A) : const Color(0xFF7C2D12);

    final valueColor = isDark ? Colors.white : const Color(0xFF111827);
    final tickColor =
        isDark ? const Color(0xFF7ED957) : const Color(0xFF077530);

    final temperature = result['temperature']?.toString() ?? '';
    final humidity = result['humidity']?.toString() ?? '';
    final ph = result['ph']?.toString() ?? '';
    final rainfall = result['rainfall']?.toString() ?? '';
    final soilType = result['soil_type']?.toString() ?? '';
    final zone = result['zone']?.toString() ?? '';

    final fertilizerPerPlant =
        Map<String, dynamic>.from(result['fertilizer_per_plant_per_week'] ?? {});
    final fertilizerTotal =
        Map<String, dynamic>.from(result['fertilizer_total_per_week'] ?? {});

    final waterPerPlant = result['water_per_plant_per_day']?.toString() ?? '0';
    final waterTotal = result['water_total_per_day']?.toString() ?? '0';

    final quantity = result['quantity']?.toString() ?? '0';

    final schedule = Map<String, dynamic>.from(result['schedule'] ?? {});
    final splitApplications = schedule['splits_per_year']?.toString() ?? '';
    final rawScheduleLines = List<String>.from(schedule['lines'] ?? <String>[]);

    final filteredScheduleLines = _removeDuplicateInstructions(rawScheduleLines);

    return Scaffold(
      backgroundColor: screenBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: titleColor,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 6),
              Center(
                child: TText(
                  'Care Schedule',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TText(
                  'Simple and clear guidance for your plant care.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: subtitleColor,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 22),

              _sectionTitle('Conditions', titleColor),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: highlightBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: highlightBorder),
                ),
                child: Column(
                  children: [
                    _detailRow(
                      'Temperature',
                      '$temperature °C',
                      subtitleColor,
                      valueColor,
                    ),
                    _detailRow(
                      'Humidity',
                      '$humidity %',
                      subtitleColor,
                      valueColor,
                    ),
                    _detailRow(
                      'pH',
                      ph,
                      subtitleColor,
                      valueColor,
                    ),
                    _detailRow(
                      'Rainfall',
                      '$rainfall mm',
                      subtitleColor,
                      valueColor,
                    ),
                    _detailRow(
                      'Soil Type',
                      soilType,
                      subtitleColor,
                      valueColor,
                    ),
                    _detailRow(
                      'Zone',
                      zone,
                      subtitleColor,
                      valueColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _sectionTitle('Per Plant Needs', titleColor),
              const SizedBox(height: 10),
              _sentenceItem(
                'Each plant needs about ${fertilizerPerPlant['N'] ?? 0} g of Nitrogen per week.',
                tickColor,
                valueColor,
              ),
              _sentenceItem(
                'Each plant needs about ${fertilizerPerPlant['P2O5'] ?? 0} g of Phosphorus per week.',
                tickColor,
                valueColor,
              ),
              _sentenceItem(
                'Each plant needs about ${fertilizerPerPlant['K2O'] ?? 0} g of Potassium per week.',
                tickColor,
                valueColor,
              ),
              _sentenceItem(
                'Each plant needs about $waterPerPlant L of water per day.',
                tickColor,
                valueColor,
              ),

              const SizedBox(height: 20),

              _sectionTitle('Total Needs', titleColor),
              const SizedBox(height: 10),
              _sentenceItem(
                'For $quantity plants, you need ${fertilizerTotal['N'] ?? 0} g of Nitrogen per week.',
                tickColor,
                valueColor,
              ),
              _sentenceItem(
                'For $quantity plants, you need ${fertilizerTotal['P2O5'] ?? 0} g of Phosphorus per week.',
                tickColor,
                valueColor,
              ),
              _sentenceItem(
                'For $quantity plants, you need ${fertilizerTotal['K2O'] ?? 0} g of Potassium per week.',
                tickColor,
                valueColor,
              ),
              _sentenceItem(
                'For $quantity plants, you need $waterTotal L of water per day.',
                tickColor,
                valueColor,
              ),
              _sentenceItem(
                'This is the total daily water amount needed for all plants.',
                tickColor,
                valueColor,
              ),

              const SizedBox(height: 20),

              _sectionTitle('Fertilizer Note', titleColor),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: noteBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: noteBorder,
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.info_rounded,
                          color: Color(0xFFF97316),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        TText(
                          'Important',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: noteTitleColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _sentenceItem(
                      'These values represent NPK nutrients: Nitrogen, Phosphorus, and Potassium.',
                      const Color(0xFFF97316),
                      noteTextColor,
                    ),
                    _sentenceItem(
                      'Use an NPK fertilizer mix that matches these values as closely as possible.',
                      const Color(0xFFF97316),
                      noteTextColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _sectionTitle('Care Instructions', titleColor),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sentenceItem(
                      'Apply fertilizer about $splitApplications times per year.',
                      tickColor,
                      valueColor,
                    ),
                    _sentenceItem(
                      'Start fertilizer after planting.',
                      tickColor,
                      valueColor,
                    ),
                    _sentenceItem(
                      'Water plants daily depending on weather.',
                      tickColor,
                      valueColor,
                    ),
                    _sentenceItem(
                      'Check soil moisture before watering.',
                      tickColor,
                      valueColor,
                    ),
                    _sentenceItem(
                      'Monitor plant growth regularly.',
                      tickColor,
                      valueColor,
                    ),
                    ...filteredScheduleLines.map(
                      (line) => _sentenceItem(
                        _formatInstruction(line),
                        tickColor,
                        valueColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static List<String> _removeDuplicateInstructions(List<String> lines) {
    bool hasStartAfterPlanting = false;
    bool hasSplitPerYear = false;
    bool hasWaterDaily = false;
    bool hasMonitor = false;

    final List<String> cleaned = [];

    for (final raw in lines) {
      final normalized = _normalizeText(raw);

      if (normalized.isEmpty) continue;

      if (normalized.contains('start fertilizer') ||
          normalized.contains('fertilizer application after planting')) {
        if (hasStartAfterPlanting) continue;
        hasStartAfterPlanting = true;
        continue;
      }

      if ((normalized.contains('split fertilizer') &&
              normalized.contains('times')) ||
          normalized.contains('apply fertilizer') &&
              normalized.contains('times per year')) {
        if (hasSplitPerYear) continue;
        hasSplitPerYear = true;
        continue;
      }

      if ((normalized.contains('water daily') ||
              normalized.contains('adjust water daily')) &&
          (normalized.contains('rainfall') ||
              normalized.contains('weather') ||
              normalized.contains('moisture'))) {
        if (hasWaterDaily) continue;
        hasWaterDaily = true;
        continue;
      }

      if (normalized.contains('monitor')) {
        if (hasMonitor) continue;
        hasMonitor = true;
        continue;
      }

      cleaned.add(raw);
    }

    return cleaned;
  }

  static String _normalizeText(String text) {
    return text
        .toLowerCase()
        .replaceAll('.', '')
        .replaceAll(',', '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String _formatInstruction(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return trimmed;
    final capitalized = trimmed[0].toUpperCase() + trimmed.substring(1);
    return capitalized.endsWith('.') ? capitalized : '$capitalized.';
  }

  Widget _sectionTitle(String text, Color color) {
    return TText(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: color,
      ),
    );
  }

  Widget _sentenceItem(String text, Color tickColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: tickColor,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TText(
              text,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(
    String label,
    String value,
    Color labelColor,
    Color valueColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: TText(
              label,
              style: TextStyle(
                fontSize: 13,
                color: labelColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}