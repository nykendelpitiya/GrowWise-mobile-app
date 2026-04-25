import 'package:flutter/material.dart';
import 'home_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:growwise_mobile_app/features/notifications/presentation/notification_screen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, Nusith",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: kTextDark,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Welcome back to GrowWise",
                style: TextStyle(
                  fontSize: 13,
                  color: kTextLight,
                ),
              ),
            ],
          ),
        ),

        /// 🔔 NOTIFICATION ICON + 🔴 RED DOT
        StreamBuilder<int>(
          stream: getUnreadCount(),
          builder: (context, snapshot) {
            final count = snapshot.data ?? 0;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFA7D7B7),
                          Color(0xFF4F8F68),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2F5D3E).withOpacity(0.18),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.notifications_none_rounded,
                        size: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  /// 🔴 RED DOT (ONLY IF UNREAD > 0)
                  if (count > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
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