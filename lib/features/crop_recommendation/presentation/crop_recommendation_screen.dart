import 'package:flutter/material.dart';
import 'package:growwise_mobile_app/features/crop_recommendation/presentation/crop_result_screen.dart';
import 'package:growwise_mobile_app/services/api_service.dart';
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

  final List<String> crops = const [
    'Tea',
    'Cinnamon',
    'Pepper',
    'Areca nut',
  ];

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
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.redAccent,
        ),
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
    const screenBg = Colors.white;
    const titleColor = Color(0xFF111827);
    const subtitleColor = Color(0xFF6B7280);
    const formBg = Color(0xFFF3FAF5);
    const formBorder = Color(0xFFDCEFE2);
    const inputFieldBg = Color(0xFFEDF4EF);
    const primaryGreen = Color(0xFF077530);

    return Scaffold(
      backgroundColor: screenBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
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
              const SizedBox(height: 12),
              const Text(
                'Crop Recommendation',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Choose your plant and location to get a recommendation.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: subtitleColor,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Align(
                  alignment: const Alignment(0, -0.26),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        decoration: BoxDecoration(
                          color: formBg,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: formBorder,
                            width: 1.2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x12000000),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.white,
                            inputDecorationTheme: InputDecorationTheme(
                              filled: true,
                              fillColor: inputFieldBg,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 16,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: Color(0xFFD7E5DA),
                                  width: 1.2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: primaryGreen,
                                  width: 1.4,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: Color(0xFFD7E5DA),
                                  width: 1.2,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: Color(0xFFD7E5DA),
                                  width: 1.2,
                                ),
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Select plant',
                                style: TextStyle(
                                  fontSize: 16,
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
                              const SizedBox(height: 18),
                              const Text(
                                'Select location',
                                style: TextStyle(
                                  fontSize: 16,
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
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
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
                                  minimumSize: const Size.fromHeight(50),
                                  elevation: 0,
                                  backgroundColor: primaryGreen,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                                child: const Text(
                                  'Recommend',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
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
}