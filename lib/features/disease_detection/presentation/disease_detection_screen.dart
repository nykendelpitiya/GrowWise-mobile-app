import 'dart:convert';
import 'dart:io' show File;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:growwise_mobile_app/services/t_text.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  final ImagePicker _picker = ImagePicker();

  final List<String> plants = const [
    'Tea',
    'Cinnamon',
    'Pepper',
    'ArecaNut',
  ];

  String selectedPlant = 'Tea';
  XFile? selectedImage;
  bool isLoading = false;
  String? detectedDisease;
  double? diseaseConfidence;

  static const String baseUrl = 'http://127.0.0.1:8000';

  Color _getConfidenceColor(double? confidence, {String? disease}) {
    final diseaseName = disease?.trim().toLowerCase();

    if (diseaseName == 'healthy') {
      return const Color(0xFF077530);
    }

    return confidence == null
        ? const Color(0xFF077530)
        : confidence >= 70
            ? const Color(0xFFDC2626)
            : const Color(0xFFF97316);
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (image == null) return;

    setState(() {
      selectedImage = image;
      detectedDisease = null;
      diseaseConfidence = null;
    });
  }

  Future<void> _detectDisease() async {
    if (selectedImage == null) {
      _showResultPopup(
        title: 'No Image Selected',
        message: 'Please upload or capture a leaf image first.',
        success: false,
      );
      return;
    }

    setState(() {
      isLoading = true;
      detectedDisease = null;
      diseaseConfidence = null;
    });

    try {
      final uri = Uri.parse('$baseUrl/predict-disease');

      final request = http.MultipartRequest('POST', uri);
      request.fields['plant'] = selectedPlant;

      final bytes = await selectedImage!.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: selectedImage!.name,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final disease = data['disease']?.toString() ?? 'Unknown Disease';
        final confidenceValue =
            double.tryParse(data['confidence']?.toString() ?? '');

        setState(() {
          detectedDisease = disease;
          diseaseConfidence = confidenceValue;
        });

        _showResultPopup(
          title: 'Detected Disease',
          message: disease,
          success: true,
          confidence: confidenceValue,
        );
      } else {
        final errorMessage =
            data['message']?.toString() ??
            data['detail']?.toString() ??
            'Disease detection failed.';

        _showResultPopup(
          title: 'Detection Failed',
          message: errorMessage,
          success: false,
        );
      }
    } catch (e) {
      _showResultPopup(
        title: 'Error',
        message: e.toString(),
        success: false,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showResultPopup({
    required String title,
    required String message,
    required bool success,
    double? confidence,
  }) {
    final confidenceColor =
        _getConfidenceColor(confidence, disease: message);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: TText(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: success ? confidenceColor : Colors.red,
            ),
          ),
          content: success && confidence != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TText(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      height: 96,
                      width: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: confidenceColor.withOpacity(0.10),
                        border: Border.all(
                          color: confidenceColor,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: confidenceColor.withOpacity(0.20),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${confidence.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: confidenceColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TText(
                      message.trim().toLowerCase() == 'healthy'
                          ? 'Healthy confidence'
                          : confidence >= 70
                              ? 'High confidence'
                              : 'Medium confidence',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: confidenceColor,
                      ),
                    ),
                  ],
                )
              : TText(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: TText(
                'OK',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: success ? confidenceColor : Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F1720) : Colors.white;
    final cardColor = isDark ? const Color(0xFF16212B) : const Color(0xFFF8FAFC);
    final titleColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtitleColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final borderColor =
        isDark ? const Color(0xFF2A3A45) : const Color(0xFFE5E7EB);

    const primaryGreen = Color(0xFF077530);
    const lightGreen = Color(0xFFEAF7EE);
    const resultTextGreen = Color(0xFF14532D);

    final confidenceColor =
        _getConfidenceColor(diseaseConfidence, disease: detectedDisease);

    final diseaseBoxBg =
        isDark ? const Color(0xFF16212B) : lightGreen;
    final diseaseBoxBorder =
        isDark ? const Color(0xFF2F6B46) : primaryGreen;
    final diseaseBoxLabelColor =
        isDark ? const Color(0xFF86EFAC) : resultTextGreen;
    final diseaseBoxValueColor =
        isDark ? Colors.white : resultTextGreen;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 34,
                    minHeight: 34,
                  ),
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: titleColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 2),
              TText(
                'Disease Detection',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 5),
              TText(
                'Upload a clear full leaf image. Avoid blurry images.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.3,
                  height: 1.35,
                  color: subtitleColor,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF111A24)
                      : const Color(0xFFF3F7F4),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: plants.map((plant) {
                    final selected = selectedPlant == plant;

                    return Expanded(
                      child: GestureDetector(
                        onTap: isLoading
                            ? null
                            : () {
                                setState(() {
                                  selectedPlant = plant;
                                  detectedDisease = null;
                                  diseaseConfidence = null;
                                });
                              },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: selected ? primaryGreen : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: primaryGreen.withOpacity(0.25),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: TText(
                              plant,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: selected ? Colors.white : titleColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: isLoading
                          ? null
                          : () => _pickImage(ImageSource.gallery),
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF16212B) : lightGreen,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF355243)
                                : const Color(0xFFCFEAD8),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload_rounded,
                              size: 18,
                              color: primaryGreen,
                            ),
                            SizedBox(width: 8),
                            TText(
                              'Upload',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: isLoading
                          ? null
                          : () => _pickImage(ImageSource.camera),
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF16A34A),
                              Color(0xFF077530),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: primaryGreen.withOpacity(0.22),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            TText(
                              'Capture',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                flex: detectedDisease == null ? 1 : 8,
                child: Container(
                  width: double.infinity,
                  padding: selectedImage == null
                      ? EdgeInsets.zero
                      : const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? cardColor : const Color(0xFFFBFDFB),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? borderColor : const Color(0xFFDCEFE3),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.22 : 0.07),
                        blurRadius: 18,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: selectedImage == null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 58,
                                width: 58,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF111A24)
                                      : lightGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 30,
                                  color: subtitleColor,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TText(
                                'No image selected',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: subtitleColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: isDark
                                ? const Color(0xFF0B1220)
                                : Colors.white,
                            child: kIsWeb
                                ? Image.network(
                                    selectedImage!.path,
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                    height: double.infinity,
                                  )
                                : Image.file(
                                    File(selectedImage!.path),
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                          ),
                        ),
                ),
              ),
              if (detectedDisease != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        height: 74,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: diseaseBoxBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: diseaseBoxBorder,
                            width: 1.6,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryGreen.withOpacity(0.12),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TText(
                              'Detected Disease',
                              style: TextStyle(
                                fontSize: 11,
                                color: diseaseBoxLabelColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 5),
                            TText(
                              detectedDisease!,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: diseaseBoxValueColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (diseaseConfidence != null) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 74,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: confidenceColor.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: confidenceColor,
                              width: 1.6,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: confidenceColor.withOpacity(0.16),
                                blurRadius: 12,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TText(
                                'Confidence',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: confidenceColor,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${diseaseConfidence!.toStringAsFixed(1)}%',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: confidenceColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _detectDisease,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: primaryGreen.withOpacity(0.5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const TText(
                          'Detect Disease',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
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