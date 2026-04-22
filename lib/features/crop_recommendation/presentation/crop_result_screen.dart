import 'package:flutter/material.dart';
import 'package:growwise_mobile_app/features/crop_recommendation/presentation/crop_recommendation_screen.dart';
import 'package:growwise_mobile_app/features/home/presentation/home_screen.dart';

class CropResultScreen extends StatelessWidget {
  final String crop;
  final String district;
  final String level;
  final double percentage;
  final bool suitable;
  final double temperature;
  final String status;
  final String message;

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
  });

  @override
  Widget build(BuildContext context) {
    const screenBg = Colors.white;
    const titleColor = Color(0xFF111827);
    const subtitleColor = Color(0xFF6B7280);
    const lineColor = Color(0xFFE5E7EB);
    const primaryGreen = Color(0xFF077530);

    final normalizedLevel = level.trim().toUpperCase();

    Color levelColor;
    Color levelBg;

    if (normalizedLevel == 'HIGH') {
      levelColor = const Color(0xFF0B6B2E);
      levelBg = const Color(0xFFEAF7EE);
    } else if (normalizedLevel == 'MEDIUM') {
      levelColor = const Color(0xFFB7791F);
      levelBg = const Color(0xFFFFF7E6);
    } else {
      levelColor = const Color(0xFFD32F2F);
      levelBg = const Color(0xFFFFEEEE);
    }

    final suitableBg =
        suitable ? const Color(0xFFEAF7EE) : const Color(0xFFFFEEEE);
    final suitableBorder =
        suitable ? const Color(0xFFCFEAD8) : const Color(0xFFF5CACA);

    final Color suitableColor;
    if (!suitable) {
      suitableColor = const Color(0xFFD32F2F);
    } else if (normalizedLevel == 'MEDIUM') {
      suitableColor = const Color(0xFFB7791F);
    } else {
      suitableColor = const Color(0xFF0B6B2E);
    }

    final messageBg =
        suitable ? const Color(0xFFFFF8E8) : const Color(0xFFFFF4E8);

    final String displayMessage;
    if (!suitable) {
      displayMessage = 'This crop is not suitable for your selected district.';
    } else if (normalizedLevel == 'MEDIUM') {
      displayMessage =
          'This crop is suitable, but you can also try another crop for a better result.';
    } else {
      displayMessage = 'This crop is suitable for your selected district.';
    }

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
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: titleColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Crop Recommendation Result',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
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
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: lineColor),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _highlightCard(
                              title: 'Crop',
                              value: crop,
                              scaleDownValue: false,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _highlightCard(
                              title: 'District',
                              value: district,
                              scaleDownValue: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 6,
                            child: Center(
                              child: _buildPercentageCircle(
                                percentage: percentage,
                                primaryGreen: primaryGreen,
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
                                  const Text(
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
                                    child: Text(
                                      normalizedLevel,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            normalizedLevel == 'MEDIUM' ? 18 : 22,
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
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: suitableBg,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: suitableBorder,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 44,
                              width: 44,
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                  const Text(
                                    'Final Recommendation',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: subtitleColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
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
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: messageBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: lineColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Message',
                              style: TextStyle(
                                fontSize: 11,
                                color: subtitleColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              displayMessage,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.35,
                                fontWeight: FontWeight.w500,
                                color: titleColor,
                              ),
                            ),
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
                                side: const BorderSide(
                                  color: Color(0xFFD1D5DB),
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: const Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: 13,
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: const Text(
                                'Back to Home',
                                style: TextStyle(
                                  fontSize: 13,
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
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
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
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                  )
                : Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
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
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Confidence',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}