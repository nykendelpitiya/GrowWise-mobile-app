import 'package:flutter/material.dart';
import 'package:growwise_mobile_app/features/crop_recommendation/presentation/crop_recommendation_screen.dart';
import 'package:growwise_mobile_app/features/home/presentation/home_screen.dart';
import 'package:growwise_mobile_app/services/t_text.dart';

class CropResultScreen extends StatelessWidget {
  final String crop;
  final String district;
  final String level;
  final double percentage;
  final bool suitable;
  final double temperature;
  final String status;
  final String message;
  final List<String> alternativeCrops;

  const CropResultScreen({
    super.key,
    required this.crop,
    required this.district,
    required this.level,
    required this.percentage,
    required this.suitable,
    required this.temperature,
    required this.status,
    required this.message,
    this.alternativeCrops = const [],
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screenBg = isDark ? const Color(0xFF0F1720) : Colors.white;
    final titleColor =
        isDark ? const Color(0xFFF3F4F6) : const Color(0xFF111827);
    final subtitleColor =
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    final lineColor =
        isDark ? const Color(0xFF2B3844) : const Color(0xFFE5E7EB);
    final surfaceColor =
        isDark ? const Color(0xFF16212B) : const Color(0xFFF8FAFC);
    const primaryGreen = Color(0xFF077530);

    final normalizedLevel = level.trim().toUpperCase();
    final showAlternatives = !suitable && alternativeCrops.isNotEmpty;

    Color levelColor;
    Color levelBg;

    if (normalizedLevel == 'HIGH') {
      levelColor = const Color(0xFF0B6B2E);
      levelBg = isDark ? const Color(0xFF1B2C24) : const Color(0xFFEAF7EE);
    } else if (normalizedLevel == 'MEDIUM') {
      levelColor = const Color(0xFFB7791F);
      levelBg = isDark ? const Color(0xFF32291A) : const Color(0xFFFFF7E6);
    } else {
      levelColor = const Color(0xFFD32F2F);
      levelBg = isDark ? const Color(0xFF351F23) : const Color(0xFFFFEEEE);
    }

    final suitableBg = suitable
        ? (isDark ? const Color(0xFF1B2C24) : const Color(0xFFEAF7EE))
        : (isDark ? const Color(0xFF351F23) : const Color(0xFFFFEEEE));

    final suitableBorder = suitable
        ? primaryGreen
        : (isDark ? const Color(0xFF5A3238) : const Color(0xFFF5CACA));

    final Color suitableColor;
    if (!suitable) {
      suitableColor = const Color(0xFFD32F2F);
    } else if (normalizedLevel == 'MEDIUM') {
      suitableColor = const Color(0xFFB7791F);
    } else {
      suitableColor = const Color(0xFF0B6B2E);
    }

    final messageBg = suitable
        ? (isDark ? const Color(0xFF174A32) : const Color(0xFFD7FCE4))
        : (isDark ? const Color(0xFF3A2520) : const Color(0xFFFFF1E3));

    final messageBorder = suitable
        ? (isDark ? const Color(0xFF7ED957) : const Color(0xFF22C55E))
        : (isDark ? const Color(0xFF704438) : const Color(0xFFF3C59B));

    final messageTextColor = suitable
        ? (isDark ? const Color(0xFFEAF7EE) : const Color(0xFF064E3B))
        : titleColor;

    final iconCircleBg = isDark ? const Color(0xFF111A24) : Colors.white;
    final outlinedButtonBg = isDark ? const Color(0xFF16212B) : Colors.white;
    final outlinedButtonBorder =
        isDark ? const Color(0xFF32414D) : const Color(0xFFD1D5DB);

    final String displayMessage;
    if (!suitable && showAlternatives) {
      displayMessage =
          '$crop is not suitable for $district. Therefore, try these recommended plants:';
    } else if (!suitable) {
      displayMessage = '$crop is not suitable for $district.';
    } else if (normalizedLevel == 'MEDIUM') {
      displayMessage =
          'This crop is suitable, but you can also try another crop for a better result.';
    } else {
      displayMessage = 'This crop is suitable for your selected district.';
    }

    final double mainGap = showAlternatives ? 12 : 18;
    final double resultGap = showAlternatives ? 12 : 14;
    final double messagePaddingY = showAlternatives ? 10 : 12;
    final double finalCardPaddingY = showAlternatives ? 14 : 16;

    return Scaffold(
      backgroundColor: screenBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: titleColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 4),
              TText(
                'Crop Recommendation Result',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              TText(
                'Final result for your selected crop and district.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: subtitleColor,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _highlightCard(
                              title: 'Crop',
                              value: crop,
                              scaleDownValue: false,
                              titleColor: subtitleColor,
                              valueColor: titleColor,
                              cardColor: surfaceColor,
                              borderColor: lineColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _highlightCard(
                              title: 'District',
                              value: district,
                              scaleDownValue: true,
                              titleColor: subtitleColor,
                              valueColor: titleColor,
                              cardColor: surfaceColor,
                              borderColor: lineColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: mainGap),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 6,
                            child: Center(
                              child: _buildPercentageCircle(
                                percentage: percentage,
                                primaryGreen: primaryGreen,
                                valueColor: titleColor,
                                subtitleColor: subtitleColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: levelBg,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: lineColor),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TText(
                                    'Level',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: subtitleColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: TText(
                                      normalizedLevel,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: normalizedLevel == 'MEDIUM'
                                            ? 18
                                            : 22,
                                        fontWeight: FontWeight.w800,
                                        color: levelColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: mainGap),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: finalCardPaddingY,
                        ),
                        decoration: BoxDecoration(
                          color: suitableBg,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: suitableBorder,
                            width: suitable ? 1.6 : 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 44,
                              width: 44,
                              decoration: BoxDecoration(
                                color: iconCircleBg,
                                shape: BoxShape.circle,
                                border: Border.all(color: suitableBorder),
                              ),
                              child: Icon(
                                suitable
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_rounded,
                                color: suitableColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TText(
                                    'Final Recommendation',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: subtitleColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  TText(
                                    suitable ? 'Suitable' : 'Not Suitable',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: suitableColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: resultGap),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: messagePaddingY,
                        ),
                        decoration: BoxDecoration(
                          color: messageBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: messageBorder,
                            width: suitable ? 1.4 : 1.1,
                          ),
                          boxShadow: suitable
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF22C55E)
                                        .withOpacity(isDark ? 0.12 : 0.18),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TText(
                              'Message',
                              style: TextStyle(
                                fontSize: 11,
                                color: suitable ? messageTextColor : subtitleColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TText(
                              displayMessage,
                              maxLines: showAlternatives ? 2 : 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.5,
                                height: 1.28,
                                fontWeight: FontWeight.w600,
                                color: messageTextColor,
                              ),
                            ),
                            if (showAlternatives) ...[
                              const SizedBox(height: 7),
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: alternativeCrops.map((cropName) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 3),
                                      child: TText(
                                        '✅ $cropName',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12.5,
                                          height: 1.1,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF077530),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CropRecommendationScreen(),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(42),
                                side: BorderSide(
                                  color: outlinedButtonBorder,
                                  width: 1,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                backgroundColor: outlinedButtonBg,
                              ),
                              child: TText(
                                'Try Again',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: titleColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(42),
                                elevation: 0,
                                backgroundColor: primaryGreen,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: const TText(
                                'Back to Home',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _highlightCard({
    required String title,
    required String value,
    required bool scaleDownValue,
    required Color titleColor,
    required Color valueColor,
    required Color cardColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TText(
            title,
            style: TextStyle(
              fontSize: 11,
              color: titleColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 28,
            width: double.infinity,
            child: scaleDownValue
                ? FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: TText(
                      value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: valueColor,
                      ),
                    ),
                  )
                : TText(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: valueColor,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPercentageCircle({
    required double percentage,
    required Color primaryGreen,
    required Color valueColor,
    required Color subtitleColor,
  }) {
    final progress = (percentage / 100).clamp(0.0, 1.0);
    const circleSize = 128.0;

    return SizedBox(
      height: circleSize,
      width: circleSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: circleSize,
            width: circleSize,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 9,
              backgroundColor: primaryGreen.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation<Color>(primaryGreen),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: valueColor,
                ),
              ),
              const SizedBox(height: 2),
              TText(
                'Confidence',
                style: TextStyle(
                  fontSize: 10,
                  color: subtitleColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}