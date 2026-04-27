import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:growwise_mobile_app/services/api_service.dart';
import 'package:growwise_mobile_app/services/care_store.dart';
import 'package:growwise_mobile_app/features/dashboard/presentation/dashboard_screen.dart';
import 'widgets/plant_dropdown_field.dart';
import 'widgets/district_dropdown_field.dart';
import 'widgets/planting_date_field.dart';
import 'widgets/quantity_input_field.dart';

class CareInputScreen extends StatefulWidget {
  const CareInputScreen({super.key});

  @override
  State<CareInputScreen> createState() => _CareInputScreenState();
}

class _CareInputScreenState extends State<CareInputScreen> {
  String? selectedCrop;
  String? selectedDistrict;
  DateTime? selectedPlantingDate;
  final TextEditingController quantityController = TextEditingController();
  bool isLoading = false;

  final List<String> crops = const [
    'Tea',
    'Cinnamon',
    'Pepper',
    'Areca nut',
  ];

  final List<String> districts = const [
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

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  Future<void> _pickPlantingDate() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedPlantingDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate != null) {
      setState(() {
        selectedPlantingDate = pickedDate;
      });
    }
  }

  Future<void> _handleSave() async {
    FocusScope.of(context).unfocus();

    final user = FirebaseAuth.instance.currentUser;
    final quantity = int.tryParse(quantityController.text.trim());

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login again'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (selectedCrop == null ||
        selectedDistrict == null ||
        selectedPlantingDate == null ||
        quantity == null ||
        quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields correctly'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiService.predictCareRecommendation(
        userId: user.uid,
        crop: selectedCrop!,
        district: selectedDistrict!,
        plantingDate: DateFormat('yyyy-MM-dd').format(selectedPlantingDate!),
        quantity: quantity,
      );

      await CareStore.saveSchedule(
        title: '${selectedCrop!} Schedule',
        result: result,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
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

  Widget _sectionLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : const Color(0xFF111827),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screenBg = isDark ? const Color(0xFF0B1622) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtitleColor =
        isDark ? const Color(0xFFB7C3D0) : const Color(0xFF6B7280);
    final cardBg =
        isDark ? const Color(0xFF16212B) : const Color(0xFFEAF7EE);
    final cardBorder =
        isDark ? const Color(0xFF4A6277) : const Color(0xFFCFEAD8);
    const primaryGreen = Color(0xFF077530);

    return Scaffold(
      backgroundColor: screenBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
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
                    size: 20,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Plant Care Setup',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Register your plant details to save the care plan and view the schedule in your dashboard.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.45,
                  color: subtitleColor,
                ),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: cardBorder,
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('Select Plant', isDark),
                    const SizedBox(height: 10),
                    PlantDropdownField(
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
                    _sectionLabel('Select District', isDark),
                    const SizedBox(height: 10),
                    DistrictDropdownField(
                      value: selectedDistrict,
                      items: districts,
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() {
                                selectedDistrict = value;
                              });
                            },
                    ),
                    const SizedBox(height: 18),
                    _sectionLabel('Planting Date', isDark),
                    const SizedBox(height: 10),
                    PlantingDateField(
                      value: selectedPlantingDate == null
                          ? ''
                          : DateFormat('yyyy-MM-dd')
                              .format(selectedPlantingDate!),
                      onTap: isLoading ? () {} : _pickPlantingDate,
                    ),
                    const SizedBox(height: 18),
                    _sectionLabel('Quantity', isDark),
                    const SizedBox(height: 10),
                    QuantityInputField(
                      controller: quantityController,
                    ),
                  ],
                ),
              ),
              const Spacer(),
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
                        onPressed: _handleSave,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(54),
                          elevation: 0,
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Save',
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
    );
  }
}