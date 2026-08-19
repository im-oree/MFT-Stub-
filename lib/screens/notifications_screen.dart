import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/models.dart';
import '../services/booking_api.dart';
import '../theme/wtr_theme.dart';
import '../util/format.dart';
import '../widgets/common.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AppNotification>? _items;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await api.getNotifications();
    if (!mounted) return;
    setState(() => _items = items);
  }

  IconData _icon(NotificationKind k) => switch (k) {
        NotificationKind.booking => Icons.event_available,
        NotificationKind.promo => Icons.local_offer_outlined,
        NotificationKind.reminder => Icons.alarm_outlined,
        NotificationKind.system => Icons.info_outline,
      };

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(title: const Text('Notifications')),
      body: _items == null
          ? const Column(children: [SkeletonSessionList(count: 4)])
          : ListView.separated(
              itemCount: _items!.length,
              separatorBuilder: (_, __) => Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(height: 1, color: p.divider),
              ),
              itemBuilder: (context, i) {
                final n = _items![i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: p.canvas,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(_icon(n.kind), color: p.ink, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n.title,
                                style: TextStyle(
                                    color: p.ink,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(height: 3),
                            Text(n.body,
                                style: TextStyle(color: p.muted, fontSize: 13, height: 1.4)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(relativeTime(n.at, MockData.today),
                          style: TextStyle(color: p.muted, fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
