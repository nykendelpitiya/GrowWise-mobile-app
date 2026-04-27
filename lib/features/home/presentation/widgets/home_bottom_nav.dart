import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:growwise_mobile_app/features/dashboard/presentation/dashboard_screen.dart';
import 'home_colors.dart';
import 'package:growwise_mobile_app/features/profile/presentation/profile_screen.dart';

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(18, 0, 18, 10),
      child: SizedBox(
        height: 78,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  height: 58,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF16212B).withOpacity(0.92)
                        : Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF2A3A45)
                          : const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.32 : 0.10),
                        blurRadius: 18,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 74),
                      _NavItem(
                        icon: Icons.dashboard_rounded,
                        label: "Dashboard",
                        active: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DashboardScreen(),
                            ),
                          );
                        },
                      ),
                      _NavItem(
                        icon: Icons.person_rounded,
                        label: "Profile",
                        active: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              left: 12,
              top: 0,
              child: _ActiveHomeItem(
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveHomeItem extends StatelessWidget {
  final VoidCallback? onTap;

  const _ActiveHomeItem({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 86,
        height: 76,
        child: Column(
          children: [
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFDCFCE7),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF22C55E).withOpacity(0.28),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(7),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF22C55E),
                      Color(0xFF16A34A),
                      Color(0xFF077530),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              "Home",
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: kPrimaryGreenDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final inactiveColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 74,
        height: 54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: inactiveColor,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}