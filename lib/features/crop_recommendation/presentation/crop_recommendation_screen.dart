import 'package:flutter/material.dart';
import 'package:growwise_mobile_app/features/crop_recommendation/presentation/crop_result_screen.dart';
import 'package:growwise_mobile_app/services/api_service.dart';
import 'package:growwise_mobile_app/services/t_text.dart';
import 'widgets/crop_dropdown_field.dart';
import 'widgets/location_dropdown_field.dart';

class CropRecommendationScreen extends StatefulWidget {
  const CropRecommendationScreen({super.key});

  @override
  State<CropRecommendationScreen> createState() =>
      _CropRecommendationScreenState();
}

class _CropRecommendationScreenState extends State<CropRecommendationScreen> {
  String? selectedCrop;
  String? selectedLocation;
  bool isLoading = false;

  final List<String> crops = const ['Tea', 'Cinnamon', 'Pepper', 'Areca nut'];

  final List<String> locations = const [
    'Ampara',
    'Anuradhapura',
    'Badulla',
    'Batticaloa',
    'Colombo',
    'Galle',
    'Gampaha',
    'Hambantota',
    'Jaffna',
    'Kalutara',
    'Kandy',
    'Kegalle',
    'Kilinochchi',
    'Kurunegala',
    'Mannar',
    'Matale',
    'Matara',
    'Monaragala',
    'Mullaitivu',
    'Nuwara Eliya',
    'Polonnaruwa',
    'Puttalam',
    'Ratnapura',
    'Trincomalee',
    'Vavuniya',
  ];

  Future<void> _handleRecommend() async {
    FocusScope.of(context).unfocus();

    if (selectedCrop == null || selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select plant and location'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiService.predictCropRecommendation(
        crop: selectedCrop!,
        district: selectedLocation!,
      );

      if (!mounted) return;

      final percentage =
          double.tryParse(result['percentage'].toString()) ?? 0.0;
      final suitable = result['suitable'] == true;
      final level = result['level']?.toString() ?? "UNKNOWN";
      final crop = result['crop']?.toString() ?? selectedCrop!;
      final district = result['district']?.toString() ?? selectedLocation!;
      final temperature =
          double.tryParse(result['temperature'].toString()) ?? 0.0;
      final status = result['status']?.toString() ?? '';
      final message = result['message']?.toString() ?? '';

      /// ✅ NEW LINE (IMPORTANT)
      final alternativeCrops =
          (result['alternative_crops'] as List?)?.map((e) => e.toString()).toList() ?? [];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CropResultScreen(
            crop: crop,
            district: district,
            level: level,
            percentage: percentage,
            suitable: suitable,
            temperature: temperature,
            status: status,
            message: message,

            /// ✅ PASS TO RESULT SCREEN
            alternativeCrops: alternativeCrops,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screenBg = isDark ? const Color(0xFF0F1720) : Colors.white;
    final titleColor =
        isDark ? const Color(0xFFF3F4F6) : const Color(0xFF111827);
    final subtitleColor =
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    const primaryGreen = Color(0xFF077530);
    final formCardBg =
        isDark ? const Color(0xFF16212B) : const Color(0xFFEAF7EE);
    final formCardBorder =
        isDark ? const Color(0xFF2A3A46) : const Color(0xFFD5EADF);

    return Scaffold(
      backgroundColor: screenBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
          child: Column(
            children: [
              Column(
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
                  const SizedBox(height: 14),
                  TText(
                    'Crop Recommendation',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TText(
                    'Select your crop and district to receive a smart suitability recommendation based on local conditions.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 70),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                decoration: BoxDecoration(
                  color: formCardBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: formCardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TText(
                      'Select Plant',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CropDropdownField(
                      value: selectedCrop,
                      items: crops,
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() {
                                selectedCrop = value;
                              });
                            },
                    ),
                    const SizedBox(height: 24),
                    TText(
                      'Select District',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LocationDropdownField(
                      value: selectedLocation,
                      items: locations,
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() {
                                selectedLocation = value;
                              });
                            },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: SizedBox(
                  width: double.infinity,
                  child: isLoading
                      ? const Center(
                          child: SizedBox(
                            height: 44,
                            width: 44,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: primaryGreen,
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _handleRecommend,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            elevation: 0,
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const TText(
                            'Get Recommendation',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}