import 'package:flutter/material.dart';
import 'home_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:growwise_mobile_app/features/notifications/presentation/notification_screen.dart';

class HomeHeader extends StatelessWidget {
  final Color? titleColor;
  final Color? subtitleColor;

  const HomeHeader({
    super.key,
    this.titleColor,
    this.subtitleColor,
  });

  /// 🔥 GET UNREAD COUNT
  Stream<int> getUnreadCount() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection("notifications")
        .where("userId", isEqualTo: user.uid)
        .where("isRead", isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> _markUnreadAsRead() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection("notifications")
        .where("userId", isEqualTo: user.uid)
        .where("isRead", isEqualTo: false)
        .get();

    final batch = FirebaseFirestore.instance.batch();

    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {"isRead": true});
    }

    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    /// 🔥 GET USER NAME
    final user = FirebaseAuth.instance.currentUser;

    final fullName =
        user?.displayName ?? user?.email?.split('@').first ?? "User";

    final firstName = fullName.trim().split(' ').first;

    /// 🔥 AUTO DARK MODE COLORS (fallback)
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final finalTitleColor =
        titleColor ?? (isDark ? Colors.white : kTextDark);

    final finalSubtitleColor =
        subtitleColor ?? (isDark ? Colors.white70 : kTextLight);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, $firstName",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: finalTitleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Welcome back to GrowWise",
                style: TextStyle(
                  fontSize: 13,
                  color: finalSubtitleColor,
                ),
              ),
            ],
          ),
        ),

        /// 🔔 NOTIFICATION ICON + COUNT BADGE
        StreamBuilder<int>(
          stream: getUnreadCount(),
          builder: (context, snapshot) {
            final count = snapshot.data ?? 0;

            return GestureDetector(
              onTap: () async {
                await _markUnreadAsRead();

                if (!context.mounted) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFA8E6B0),
                          Color(0xFF077530),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF077530).withOpacity(0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.notifications_none_rounded,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  /// 🔴 REAL COUNT BADGE
                  if (count > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF3B30),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}