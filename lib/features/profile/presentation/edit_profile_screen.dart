import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  final List<String> _districts = const [
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

  String? _selectedDistrict;
  bool isLoading = true;
  bool isSaving = false;
  String imageUrl = "";

  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final user = currentUser;
      if (user == null) {
        if (!mounted) return;
        setState(() => isLoading = false);
        return;
      }

      _nameController.text = user.displayName ?? '';
      _emailController.text = user.email ?? '';

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = doc.data();
      final district = (data?['district'] as String?)?.trim();

      if (!mounted) return;

      setState(() {
        imageUrl = (data?['imageUrl'] ?? "").toString();
        if (district != null && district.isNotEmpty) {
          _selectedDistrict = district;
        }
        if ((data?['fullName']?.toString().trim().isNotEmpty == true)) {
          _nameController.text = data!['fullName'].toString();
        }
        if ((data?['email']?.toString().trim().isNotEmpty == true)) {
          _emailController.text = data!['email'].toString();
        }
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      _showSnackBar('Failed to load user details');
    }
  }

  Future<void> _saveDetails() async {
    final user = currentUser;
    if (user == null) return;

    final fullName = _nameController.text.trim();
    final email = _emailController.text.trim();
    final district = (_selectedDistrict ?? '').trim();

    if (fullName.isEmpty) {
      _showSnackBar('Please enter your full name');
      return;
    }

    if (email.isEmpty) {
      _showSnackBar('Please enter your email');
      return;
    }

    if (!email.contains('@')) {
      _showSnackBar('Please enter a valid email');
      return;
    }

    if (district.isEmpty) {
      _showSnackBar('Please select district');
      return;
    }

    setState(() => isSaving = true);

    try {
      if ((user.displayName ?? '') != fullName) {
        await user.updateDisplayName(fullName);
      }

      if ((user.email ?? '') != email) {
        await user.updateEmail(email);
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {
          'fullName': fullName,
          'email': email,
          'district': district,
          'imageUrl': imageUrl,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      await user.reload();

      if (!mounted) return;

      _showSnackBar(
        'Profile updated successfully',
        isError: false,
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = 'Failed to update details';

      if (e.code == 'requires-recent-login') {
        message = 'Please login again before changing email';
      } else if (e.code == 'email-already-in-use') {
        message = 'This email is already in use';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }

      _showSnackBar(message);
    } catch (e) {
      _showSnackBar('Something went wrong');
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  void _showImagePlaceholder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile image update feature coming soon'),
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fillColor = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark ? const Color(0xFF355C44) : const Color(0xFFBBF7D0);
    final focusedBorderColor = isDark ? const Color(0xFF86EFAC) : const Color(0xFF077530);
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final helperColor = isDark ? const Color(0xFFCBD5E1) : Colors.black45;

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: textColor),
      prefixIcon: Icon(icon, color: isDark ? const Color(0xFF86EFAC) : Colors.black45),
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: borderColor,
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: focusedBorderColor,
          width: 1.4,
        ),
      ),
      hintStyle: TextStyle(color: helperColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenBackground = isDark ? const Color(0xFF0B1220) : Colors.white;
    final backIconColor = theme.iconTheme.color ?? (isDark ? Colors.white : Colors.black);
    final backTitleColor =
        theme.textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black);
    final borderColor = isDark ? const Color(0xFF355C44) : const Color(0xFFBBF7D0);
    final cardBackground = isDark ? const Color(0xFF111827) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtitleColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF6B7280);
    final previewAvatarBackground = isDark ? const Color(0xFF1F2937) : const Color(0xFFDCFCE7);
    final dropdownMenuColor = isDark ? const Color(0xFF111827) : Colors.white;
    final dropdownTextColor = isDark ? Colors.white : const Color(0xFF111827);

    final previewName =
        _nameController.text.trim().isEmpty ? "User" : _nameController.text.trim();
    final previewEmail = _emailController.text.trim().isEmpty ? "-" : _emailController.text.trim();

    return Scaffold(
      backgroundColor: screenBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 2,
        toolbarHeight: 58,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: backIconColor,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "Edit Profile",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: backTitleColor,
              ),
            ),
          ],
        ),
        backgroundColor: screenBackground,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: isDark ? Colors.white : const Color(0xFF077530),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardBackground,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: borderColor,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black.withOpacity(0.35) : Colors.black.withOpacity(0.035),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: previewAvatarBackground,
                                backgroundImage: imageUrl.trim().isNotEmpty
                                    ? NetworkImage(imageUrl)
                                    : null,
                                child: imageUrl.trim().isEmpty
                                    ? const Icon(
                                        Icons.person,
                                        size: 33,
                                        color: Color(0xFF077530),
                                      )
                                    : null,
                              ),
                              Positioned(
                                right: -2,
                                bottom: -2,
                                child: GestureDetector(
                                  onTap: _showImagePlaceholder,
                                  child: Container(
                                    height: 28,
                                    width: 28,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF077530),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_rounded,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  previewName,
                                  style: TextStyle(
                                    fontSize: 17.5,
                                    fontWeight: FontWeight.w700,
                                    color: titleColor,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  previewEmail,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardBackground,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: borderColor,
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Update your profile",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: titleColor,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Change your personal information here.",
                            style: TextStyle(
                              fontSize: 13,
                              color: subtitleColor,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _nameController,
                      onChanged: (_) => setState(() {}),
                      decoration: _inputDecoration(
                        label: 'Full Name',
                        icon: Icons.person_outline_rounded,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) => setState(() {}),
                      decoration: _inputDecoration(
                        label: 'Email',
                        icon: Icons.email_outlined,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedDistrict,
                      style: TextStyle(
                        color: dropdownTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      iconEnabledColor: dropdownTextColor,
                      decoration: _inputDecoration(
                        label: 'District',
                        icon: Icons.location_on_outlined,
                      ),
                      items: _districts
                          .map(
                            (district) => DropdownMenuItem(
                              value: district,
                              child: Text(
                                district,
                                style: TextStyle(color: dropdownTextColor),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDistrict = value;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      dropdownColor: dropdownMenuColor,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isSaving ? null : _saveDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF077530),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: isSaving
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
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