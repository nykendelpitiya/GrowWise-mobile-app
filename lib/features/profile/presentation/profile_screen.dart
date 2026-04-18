import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:growwise_mobile_app/core/theme/theme_provider.dart';
import 'package:growwise_mobile_app/features/auth/presentation/login_screen.dart';
import 'package:growwise_mobile_app/features/profile/presentation/personal_details_screen.dart';
import 'package:growwise_mobile_app/features/profile/presentation/edit_profile_screen.dart';
import 'package:growwise_mobile_app/features/profile/presentation/change_password_screen.dart';

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
        content: Text("Profile image update feature coming soon"),
      ),
    );
  }

  Future<void> _updateNotifications(bool value) async {
    final currentUser = user;
    if (currentUser == null) return;

    setState(() => notifications = value);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .set(
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenBackground = isDark ? const Color(0xFF0B1220) : Colors.white;
    final backIconColor = theme.iconTheme.color ?? (isDark ? Colors.white : Colors.black);
    final backTitleColor =
        theme.textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black);

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: screenBackground,
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
                  final topPadding = compact ? 12.0 : 16.0;
                  final bottomPadding = compact ? 14.0 : 20.0;
                  final headerGap = compact ? 10.0 : 14.0;
                  final sectionGap = compact ? 10.0 : 12.0;
                  final tileGap = compact ? 8.0 : 10.0;
                  final groupGap = compact ? 12.0 : 16.0;

                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      topPadding,
                      horizontalPadding,
                      bottomPadding,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: _handleBackTap,
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                size: 18,
                                color: backIconColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Profile",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: backTitleColor,
                              ),
                            ),
                          ],
                        ),
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
                        ProfileSwitchTile(
                          title: "Notifications",
                          value: notifications,
                          lightIcon: Icons.notifications_none_rounded,
                          darkIcon: Icons.notifications_active_outlined,
                          onChanged: _updateNotifications,
                        ),
                        const Spacer(),
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