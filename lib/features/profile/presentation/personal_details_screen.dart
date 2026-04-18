import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  bool isLoading = true;

  String fullName = "User";
  String email = "";
  String district = "";
  String imageUrl = "";

  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final user = currentUser;
      if (user == null) {
        if (!mounted) return;
        setState(() => isLoading = false);
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = doc.data();

      debugPrint("UID: ${user.uid}");
      debugPrint("Firestore data: $data");

      if (!mounted) return;

      setState(() {
        fullName = (data?['fullName']?.toString().trim().isNotEmpty == true)
            ? data!['fullName'].toString()
            : ((user.displayName?.trim().isNotEmpty == true)
                ? user.displayName!
                : "User");

        email = user.email?.trim().isNotEmpty == true
            ? user.email!
            : (data?['email'] ?? "").toString();

        district = (data?['district'] ?? "").toString();
        imageUrl = (data?['imageUrl'] ?? "").toString();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading personal details: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Widget _detailCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBackground = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark ? const Color(0xFF355C44) : const Color(0xFFBBF7D0);
    final iconBackground = isDark ? const Color(0xFF1F2937) : const Color(0xFFECFDF3);
    final iconColor = isDark ? const Color(0xFF86EFAC) : const Color(0xFF077530);
    final titleColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF6B7280);
    final valueColor = isDark ? Colors.white : const Color(0xFF111827);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: titleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.trim().isEmpty ? "-" : value,
                  style: TextStyle(
                    fontSize: 14.5,
                    color: valueColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
    final iconBackground = isDark ? const Color(0xFF1F2937) : const Color(0xFFDCFCE7);
    final titleColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtitleColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF6B7280);

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
              "Personal Details",
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
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                children: [
                  Container(
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
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: iconBackground,
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fullName.trim().isEmpty ? "User" : fullName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: titleColor,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                email.trim().isEmpty ? "-" : email,
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
                  _detailCard(
                    context: context,
                    icon: Icons.person_outline_rounded,
                    label: "Full Name",
                    value: fullName,
                  ),
                  const SizedBox(height: 10),
                  _detailCard(
                    context: context,
                    icon: Icons.email_outlined,
                    label: "Email",
                    value: email,
                  ),
                  const SizedBox(height: 10),
                  _detailCard(
                    context: context,
                    icon: Icons.location_on_outlined,
                    label: "District",
                    value: district,
                  ),
                ],
              ),
            ),
    );
  }
}