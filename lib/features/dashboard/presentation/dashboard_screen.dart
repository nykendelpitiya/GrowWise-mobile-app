import 'package:flutter/material.dart';
import 'package:growwise_mobile_app/services/care_store.dart';
import 'package:growwise_mobile_app/features/care_recommendation/presentation/care_result_screen.dart';
import 'package:growwise_mobile_app/features/home/presentation/widgets/home_bottom_nav.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Map<String, dynamic>>> _schedulesFuture;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  void _loadSchedules() {
    _schedulesFuture = CareStore.getSchedules();
  }

  Future<void> _refreshSchedules() async {
    setState(() {
      _loadSchedules();
    });
  }

  Future<void> _deleteSchedule(String docId) async {
    await CareStore.deleteSchedule(docId);
    _refreshSchedules();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screenBg = isDark ? const Color(0xFF0B1622) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtitleColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563);

    final cardBg = isDark ? const Color(0xFF16212B) : Colors.white;
    final cardBorder =
        isDark ? const Color(0xFF2E4153) : const Color(0xFFE5E7EB);

    final accentBg = isDark ? const Color(0xFF1B3324) : const Color(0xFFEAF7EE);
    final accentBorder =
        isDark ? const Color(0xFF2F6B46) : const Color(0xFFC6E7D1);

    final deleteBg = isDark ? const Color(0xFF0F2234) : const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: screenBg,
     bottomNavigationBar: const HomeBottomNav(currentIndex: 1),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _schedulesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF077530),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Failed to load schedules.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }

            final schedules = snapshot.data ?? [];

            return RefreshIndicator(
              color: const Color(0xFF077530),
              onRefresh: _refreshSchedules,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
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
                        color: titleColor,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'View and manage your saved plant care schedules.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.45,
                        color: subtitleColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (schedules.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: cardBorder,
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.event_note_rounded,
                            size: 56,
                            color: isDark
                                ? const Color(0xFF7ED957)
                                : const Color(0xFF077530),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'No schedules yet',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: titleColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Saved plant care schedules will appear here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...schedules.map((item) {
                      final title =
                          item['title']?.toString() ?? 'Plant Schedule';
                      final crop = item['crop']?.toString() ?? '';
                      final district = item['district']?.toString() ?? '';
                      final plantingDate =
                          item['planting_date']?.toString() ?? '';
                      final quantity = item['quantity']?.toString() ?? '';
                      final docId = item['doc_id']?.toString() ?? '';
                      final result =
                          Map<String, dynamic>.from(item['result'] ?? {});

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CareResultScreen(result: result),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: cardBorder,
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black.withOpacity(0.18)
                                      : const Color(0x10000000),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 6,
                                  height: 108,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF077530),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 19,
                                                height: 1.2,
                                                fontWeight: FontWeight.w800,
                                                color: titleColor,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              crop,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: titleColor,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              district,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: subtitleColor,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              plantingDate,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w500,
                                                color: subtitleColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          if (docId.isNotEmpty)
                                            InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              onTap: () =>
                                                  _deleteSchedule(docId),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: deleteBg,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: cardBorder,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons
                                                      .delete_outline_rounded,
                                                  size: 19,
                                                  color: isDark
                                                      ? Colors.white70
                                                      : const Color(
                                                          0xFF6B7280),
                                                ),
                                              ),
                                            ),
                                          const SizedBox(height: 14),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 13,
                                              vertical: 9,
                                            ),
                                            decoration: BoxDecoration(
                                              color: accentBg,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              border: Border.all(
                                                color: accentBorder,
                                                width: 1.3,
                                              ),
                                              boxShadow: isDark
                                                  ? []
                                                  : [
                                                      const BoxShadow(
                                                        color:
                                                            Color(0x12077530),
                                                        blurRadius: 8,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                            ),
                                            child: Text(
                                              '$quantity plants',
                                              style: TextStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w800,
                                                color: isDark
                                                    ? Colors.white
                                                    : const Color(0xFF166534),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}