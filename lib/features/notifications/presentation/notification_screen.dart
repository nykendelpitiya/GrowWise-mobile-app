import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:growwise_mobile_app/services/t_text.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String selectedStatus = "All";
  String selectedCategory = "All";

  final List<String> categories = const [
    "All",
    "Water",
    "Weather",
    "Fertilizer",
    "General",
  ];

  static const Color primaryGreen = Color(0xFF077530);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _markDueUnreadAsRead(user.uid);
      }
    });
  }

  bool _isDue(Map<String, dynamic> data) {
    final scheduledAt = data['scheduledAt'];

    if (scheduledAt is Timestamp) {
      return !scheduledAt.toDate().isAfter(DateTime.now());
    }

    return true;
  }

  dynamic _displayTimestamp(Map<String, dynamic> data) {
    return data['sentAt'] ?? data['createdAt'] ?? data['scheduledAt'];
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF071426) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtitleColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: user == null
            ? Center(
                child: TText(
                  "User not logged in",
                  style: TextStyle(color: subtitleColor),
                ),
              )
            : Column(
                children: [
                  _buildHeader(
                    context: context,
                    userId: user.uid,
                    titleColor: titleColor,
                  ),
                  _buildCategories(),
                  const SizedBox(height: 6),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("notifications")
                          .where("userId", isEqualTo: user.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return _emptyState(
                            icon: Icons.error_outline_rounded,
                            title: "Failed to load notifications",
                            subtitle: snapshot.error.toString(),
                            color: subtitleColor,
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: primaryGreen,
                            ),
                          );
                        }

                        final allDocs =
                            (snapshot.data?.docs ?? []).where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return _isDue(data);
                        }).toList();

                        allDocs.sort((a, b) {
                          final aData = a.data() as Map<String, dynamic>;
                          final bData = b.data() as Map<String, dynamic>;

                          final aTime = _displayTimestamp(aData);
                          final bTime = _displayTimestamp(bData);

                          if (aTime is Timestamp && bTime is Timestamp) {
                            return bTime.compareTo(aTime);
                          }
                          return 0;
                        });

                        final filteredDocs = allDocs.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final type = _getNotificationType(data);
                          final isRead = data['isRead'] == true;
                          final isImportant = data['isImportant'] == true ||
                              data['important'] == true ||
                              type == "Weather";

                          final statusOk = selectedStatus == "All" ||
                              (selectedStatus == "Unread" && !isRead) ||
                              (selectedStatus == "Important" && isImportant);

                          final categoryOk = selectedCategory == "All" ||
                              selectedCategory == type;

                          return statusOk && categoryOk;
                        }).toList();

                        if (filteredDocs.isEmpty) {
                          return _emptyState(
                            icon: Icons.notifications_none_rounded,
                            title: "No notifications yet",
                            subtitle:
                                "Only due plant care reminders will appear here.",
                            color: subtitleColor,
                          );
                        }

                        final grouped = _groupNotifications(filteredDocs);

                        return RefreshIndicator(
                          color: primaryGreen,
                          onRefresh: () async {
                            await Future.delayed(
                              const Duration(milliseconds: 500),
                            );
                          },
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
                            children: grouped.entries.map((entry) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 8,
                                      left: 4,
                                    ),
                                    child: TText(
                                      entry.key,
                                      style: TextStyle(
                                        color: subtitleColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  ...entry.value.map((doc) {
                                    final data =
                                        doc.data() as Map<String, dynamic>;

                                    return _notificationCard(
                                      context: context,
                                      docId: doc.id,
                                      data: data,
                                      titleColor: titleColor,
                                      subtitleColor: subtitleColor,
                                      isDark: isDark,
                                    );
                                  }),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader({
    required BuildContext context,
    required String userId,
    required Color titleColor,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 28, 12, 8),
      child: SizedBox(
        height: 56,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: titleColor,
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("notifications")
                  .where("userId", isEqualTo: userId)
                  .where("isRead", isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                final unreadCount = (snapshot.data?.docs ?? []).where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return _isDue(data);
                }).length;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TText(
                      "Notifications",
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (unreadCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          unreadCount > 99 ? "99+" : unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: PopupMenuButton<String>(
                color: Colors.white,
                surfaceTintColor: Colors.white,
                elevation: 6,
                icon: Icon(Icons.more_vert_rounded, color: titleColor),
                onSelected: (value) async {
                  if (value == "all") {
                    setState(() => selectedStatus = "All");
                  } else if (value == "unread") {
                    setState(() => selectedStatus = "Unread");
                  } else if (value == "important") {
                    setState(() => selectedStatus = "Important");
                  } else if (value == "read_all") {
                    await _markAllAsRead(userId);
                  } else if (value == "clear_all") {
                    await _clearAllNotifications(userId);
                  }
                },
                itemBuilder: (context) => [
                  CheckedPopupMenuItem(
                    value: "all",
                    checked: selectedStatus == "All",
                    child: const TText(
                      "Show all",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  CheckedPopupMenuItem(
                    value: "unread",
                    checked: selectedStatus == "Unread",
                    child: const TText(
                      "Show unread",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  CheckedPopupMenuItem(
                    value: "important",
                    checked: selectedStatus == "Important",
                    child: const TText(
                      "Show important",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: "read_all",
                    child: Row(
                      children: [
                        Icon(Icons.done_all_rounded,
                            size: 18, color: Colors.black87),
                        SizedBox(width: 8),
                        TText(
                          "Mark all as read",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: "clear_all",
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded,
                            size: 18, color: Colors.black87),
                        SizedBox(width: 8),
                        TText(
                          "Clear due notifications",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final item = categories[index];
          final selected = selectedCategory == item;

          return GestureDetector(
            onTap: () => setState(() => selectedCategory = item),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? primaryGreen : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected ? primaryGreen : const Color(0xFFE5E7EB),
                ),
              ),
              child: TText(
                item,
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF111827),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _notificationCard({
    required BuildContext context,
    required String docId,
    required Map<String, dynamic> data,
    required Color titleColor,
    required Color subtitleColor,
    required bool isDark,
  }) {
    final title = data['title']?.toString() ?? 'GrowWise Alert';
    final message =
        data['body']?.toString() ?? data['message']?.toString() ?? '';
    final timestamp = _displayTimestamp(data);
    final isRead = data['isRead'] == true;
    final isImportant = data['isImportant'] == true ||
        data['important'] == true ||
        _getNotificationType(data) == "Weather";

    final type = _getNotificationType(data);
    final typeStyle = _getTypeStyle(type);

    return Dismissible(
      key: ValueKey(docId),
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: primaryGreen,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            Icon(Icons.done_rounded, color: Colors.white),
            SizedBox(width: 8),
            TText(
              "Mark read",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TText(
              "Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.delete_outline_rounded, color: Colors.white),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await _markAsRead(docId);
          return false;
        }

        if (direction == DismissDirection.endToStart) {
          await _deleteNotification(docId);
          return true;
        }

        return false;
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          await _markAsRead(docId);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: TText("$type notification opened"),
              backgroundColor: primaryGreen,
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF16212B) : typeStyle.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: typeStyle.borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: typeStyle.iconColor.withOpacity(isDark ? 0.12 : 0.10),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Opacity(
            opacity: isRead ? 0.78 : 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: typeStyle.iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    typeStyle.icon,
                    color: typeStyle.iconColor,
                    size: 17,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isImportant)
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.star_rounded,
                                color: typeStyle.iconColor,
                                size: 15,
                              ),
                            ),
                          Expanded(
                            child: TText(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight:
                                    isRead ? FontWeight.w600 : FontWeight.w800,
                                fontSize: 13.5,
                                color: titleColor,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              height: 8,
                              width: 8,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                color: typeStyle.iconColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ExpandableText(
                        text: message,
                        style: TextStyle(
                          fontSize: 12.4,
                          color: subtitleColor,
                          height: 1.30,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: typeStyle.iconBgColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TText(
                              type,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: typeStyle.iconColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTime(timestamp),
                            style: TextStyle(
                              fontSize: 10.3,
                              color: subtitleColor,
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
      ),
    );
  }

  Map<String, List<QueryDocumentSnapshot>> _groupNotifications(
    List<QueryDocumentSnapshot> docs,
  ) {
    final Map<String, List<QueryDocumentSnapshot>> grouped = {
      "Today": [],
      "Yesterday": [],
      "Older": [],
    };

    final now = DateTime.now();

    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final timestamp = _displayTimestamp(data);

      if (timestamp is Timestamp) {
        final dt = timestamp.toDate();
        final today = DateTime(now.year, now.month, now.day);
        final itemDate = DateTime(dt.year, dt.month, dt.day);
        final diff = today.difference(itemDate).inDays;

        if (diff == 0) {
          grouped["Today"]!.add(doc);
        } else if (diff == 1) {
          grouped["Yesterday"]!.add(doc);
        } else {
          grouped["Older"]!.add(doc);
        }
      } else {
        grouped["Older"]!.add(doc);
      }
    }

    grouped.removeWhere((key, value) => value.isEmpty);
    return grouped;
  }

  Widget _emptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 46, color: color.withOpacity(0.7)),
            const SizedBox(height: 12),
            TText(
              title,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            TText(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color.withOpacity(0.85),
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _markAsRead(String docId) async {
    await FirebaseFirestore.instance
        .collection("notifications")
        .doc(docId)
        .update({"isRead": true});
  }

  Future<void> _markDueUnreadAsRead(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("notifications")
        .where("userId", isEqualTo: userId)
        .where("isRead", isEqualTo: false)
        .get();

    final batch = FirebaseFirestore.instance.batch();

    for (final doc in snapshot.docs) {
      final data = doc.data();

      if (_isDue(data)) {
        batch.update(doc.reference, {"isRead": true});
      }
    }

    await batch.commit();
  }

  Future<void> _deleteNotification(String docId) async {
    await FirebaseFirestore.instance
        .collection("notifications")
        .doc(docId)
        .delete();
  }

  Future<void> _markAllAsRead(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("notifications")
        .where("userId", isEqualTo: userId)
        .where("isRead", isEqualTo: false)
        .get();

    final batch = FirebaseFirestore.instance.batch();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      if (_isDue(data)) {
        batch.update(doc.reference, {"isRead": true});
      }
    }

    await batch.commit();
  }

  Future<void> _clearAllNotifications(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("notifications")
        .where("userId", isEqualTo: userId)
        .get();

    final batch = FirebaseFirestore.instance.batch();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      if (_isDue(data)) {
        batch.delete(doc.reference);
      }
    }

    await batch.commit();
  }

  String _getNotificationType(Map<String, dynamic> data) {
    final rawType = data['type']?.toString().toLowerCase() ?? '';
    final title = data['title']?.toString().toLowerCase() ?? '';
    final body =
        (data['body'] ?? data['message'] ?? '').toString().toLowerCase();

    if (rawType.contains('weather') ||
        title.contains('weather') ||
        body.contains('weather')) {
      return "Weather";
    }

    if (rawType.contains('water') ||
        title.contains('water') ||
        body.contains('water')) {
      return "Water";
    }

    if (rawType.contains('fertilizer') ||
        title.contains('fertilizer') ||
        body.contains('fertilizer')) {
      return "Fertilizer";
    }

    return "General";
  }

  _NotificationTypeStyle _getTypeStyle(String type) {
    switch (type) {
      case "Water":
        return const _NotificationTypeStyle(
          icon: Icons.water_drop_rounded,
          iconColor: Color(0xFF0284C7),
          iconBgColor: Color(0xFFDFF3FF),
          cardColor: Color(0xFFEAF7FF),
          borderColor: Color(0xFF7DD3FC),
        );

      case "Weather":
        return const _NotificationTypeStyle(
          icon: Icons.cloud_rounded,
          iconColor: Color(0xFFF97316),
          iconBgColor: Color(0xFFFFE8CC),
          cardColor: Color(0xFFFFF1DB),
          borderColor: Color(0xFFFDBA74),
        );

      case "Fertilizer":
        return const _NotificationTypeStyle(
          icon: Icons.grass_rounded,
          iconColor: Color(0xFF16A34A),
          iconBgColor: Color(0xFFDDFBE8),
          cardColor: Color(0xFFE9FFF0),
          borderColor: Color(0xFF86EFAC),
        );

      default:
        return const _NotificationTypeStyle(
          icon: Icons.notifications_active_rounded,
          iconColor: Color(0xFF7C3AED),
          iconBgColor: Color(0xFFF0E6FF),
          cardColor: Color(0xFFF8F0FF),
          borderColor: Color(0xFFC4B5FD),
        );
    }
  }

  String _formatTime(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final dt = timestamp.toDate().toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);

      if (diff.inSeconds < 60) return "Just now";
      if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
      if (diff.inHours < 24) return "${diff.inHours} hr ago";

      final hour = dt.hour.toString().padLeft(2, '0');
      final minute = dt.minute.toString().padLeft(2, '0');

      return "${dt.day}/${dt.month}/${dt.year} $hour:$minute";
    }

    return "";
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const ExpandableText({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: TText(
        widget.text,
        maxLines: expanded ? null : 2,
        overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
        style: widget.style,
      ),
    );
  }
}

class _NotificationTypeStyle {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final Color cardColor;
  final Color borderColor;

  const _NotificationTypeStyle({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.cardColor,
    required this.borderColor,
  });
}