import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:growwise_mobile_app/core/theme/theme_provider.dart';
import 'package:growwise_mobile_app/features/auth/presentation/login_screen.dart';
import 'package:growwise_mobile_app/features/profile/presentation/personal_details_screen.dart';
import 'package:growwise_mobile_app/features/profile/presentation/edit_profile_screen.dart';
import 'package:growwise_mobile_app/features/profile/presentation/change_password_screen.dart';
import 'package:growwise_mobile_app/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:growwise_mobile_app/services/t.dart';
import 'package:growwise_mobile_app/services/t_text.dart';

import 'widgets/profile_header.dart';
import 'widgets/profile_section_title.dart';
import 'widgets/profile_menu_tile.dart';
import 'widgets/profile_switch_tile.dart';
import 'widgets/logout_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notifications = true;
  bool isLoading = true;

  String fullName = "User";
  String email = "";
  String district = "";
  String imageUrl = "";

  User? get user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final currentUser = user;
      if (currentUser == null) {
        if (!mounted) return;
        setState(() => isLoading = false);
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      final data = doc.data();

      if (!mounted) return;

      setState(() {
        fullName = (data?['fullName']?.toString().trim().isNotEmpty == true)
            ? data!['fullName'].toString()
            : ((currentUser.displayName?.trim().isNotEmpty == true)
                ? currentUser.displayName!
                : "User");

        email = (data?['email']?.toString().trim().isNotEmpty == true)
            ? data!['email'].toString()
            : (currentUser.email ?? "");

        district = (data?['district'] ?? "").toString();
        imageUrl = (data?['imageUrl'] ?? "").toString();
        notifications = (data?['notifications'] is bool)
            ? data!['notifications'] as bool
            : true;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading profile: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> _goToEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EditProfileScreen(),
      ),
    );
    await _loadUserData();
  }

  void _goToPersonalDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PersonalDetailsScreen(),
      ),
    );
  }

  void _goToChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ChangePasswordScreen(),
      ),
    );
  }

  void _onProfileImageTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: TText("Profile image update feature coming soon"),
      ),
    );
  }

  Future<void> _updateNotifications(bool value) async {
    final currentUser = user;
    if (currentUser == null) return;

    setState(() => notifications = value);

    try {
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set(
        {
          'notifications': value,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint("Error updating notifications: $e");
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  void _handleBackTap() {
    Navigator.pop(context);
  }

  void _showLanguageDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1F2937)
                        : const Color(0xFFEAF7EE),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFBBF7D0),
                      width: 1.2,
                    ),
                  ),
                  child: const Icon(
                    Icons.translate_rounded,
                    color: Color(0xFF077530),
                    size: 26,
                  ),
                ),
                const SizedBox(height: 12),
                TText(
                  "Select Language",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 6),
                TText(
                  "Choose your preferred app language",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.35,
                    color: isDark
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 18),
                _languageOption(
                  label: "English",
                  value: "en",
                  shortCode: "EN",
                ),
                const SizedBox(height: 10),
                _languageOption(
                  label: "සිංහල",
                  value: "si",
                  shortCode: "සි",
                ),
                const SizedBox(height: 10),
                _languageOption(
                  label: "தமிழ்",
                  value: "ta",
                  shortCode: "த",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _languageOption({
    required String label,
    required String value,
    required String shortCode,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selected = T.instance.currentLanguage == value;

    final cardColor = selected
        ? (isDark ? const Color(0xFF12351F) : const Color(0xFFEAF7EE))
        : (isDark ? const Color(0xFF1F2937) : const Color(0xFFF8FAFC));

    final borderColor =
        selected ? const Color(0xFF077530) : const Color(0xFFE5E7EB);

    final textColor = selected
        ? const Color(0xFF077530)
        : (isDark ? Colors.white : const Color(0xFF111827));

    final codeBg = selected
        ? const Color(0xFF077530)
        : (isDark ? const Color(0xFF111827) : Colors.white);

    final codeColor = selected
        ? Colors.white
        : (isDark ? const Color(0xFF86EFAC) : const Color(0xFF077530));

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        setState(() {
          T.instance.changeLanguage(value);
        });

        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: borderColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: codeBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF077530)
                      : const Color(0xFFBBF7D0),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  shortCode,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: codeColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TText(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF077530),
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  String _languageLabel() {
    if (T.instance.currentLanguage == "si") return "සිංහල";
    if (T.instance.currentLanguage == "ta") return "தமிழ்";
    return "English";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenBackground = isDark ? const Color(0xFF0B1220) : Colors.white;
    final backIconColor =
        theme.iconTheme.color ?? (isDark ? Colors.white : Colors.black);

    final themeProvider = Provider.of<ThemeProvider>(context);
    Provider.of<T>(context);

    return Scaffold(
      backgroundColor: screenBackground,
      bottomNavigationBar: const HomeBottomNav(currentIndex: 2),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: isDark ? Colors.white : const Color(0xFF077530),
                ),
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxHeight < 760;
                  final horizontalPadding = compact ? 16.0 : 18.0;
                  final topPadding = compact ? 8.0 : 12.0;
                  final bottomPadding = compact ? 6.0 : 8.0;
                  final headerGap = compact ? 8.0 : 10.0;
                  final sectionGap = compact ? 8.0 : 10.0;
                  final tileGap = compact ? 7.0 : 8.0;
                  final groupGap = compact ? 10.0 : 12.0;

                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      topPadding,
                      horizontalPadding,
                      bottomPadding,
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: _handleBackTap,
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                              color: backIconColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: headerGap),
                                ProfileHeader(
                                  name: fullName,
                                  email: email,
                                  district: district,
                                  imageUrl: imageUrl,
                                  onEditTap: _goToEditProfile,
                                  onImageTap: _onProfileImageTap,
                                ),
                                SizedBox(height: groupGap),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: ProfileSectionTitle(title: "Account"),
                                ),
                                SizedBox(height: sectionGap),
                                ProfileMenuTile(
                                  icon: Icons.person_outline_rounded,
                                  title: "Personal Details",
                                  onTap: _goToPersonalDetails,
                                ),
                                SizedBox(height: tileGap),
                                ProfileMenuTile(
                                  icon: Icons.lock_outline_rounded,
                                  title: "Change Password",
                                  onTap: _goToChangePassword,
                                ),
                                SizedBox(height: groupGap),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: ProfileSectionTitle(title: "Settings"),
                                ),
                                SizedBox(height: sectionGap),
                                ProfileSwitchTile(
                                  title: "Dark Mode",
                                  value: themeProvider.isDarkMode,
                                  lightIcon: Icons.light_mode_outlined,
                                  darkIcon: Icons.dark_mode_outlined,
                                  onChanged: (v) {
                                    themeProvider.toggleTheme(v);
                                  },
                                ),
                                SizedBox(height: tileGap),
                                ProfileMenuTile(
                                  icon: Icons.language_rounded,
                                  title: "Language  •  ${_languageLabel()}",
                                  onTap: _showLanguageDialog,
                                ),
                                SizedBox(height: tileGap),
                                ProfileSwitchTile(
                                  title: "Notifications",
                                  value: notifications,
                                  lightIcon: Icons.notifications_none_rounded,
                                  darkIcon: Icons.notifications_active_outlined,
                                  onChanged: _updateNotifications,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: groupGap),
                        LogoutButton(
                          onTap: _logout,
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}