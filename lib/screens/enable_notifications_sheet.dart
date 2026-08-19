import 'package:flutter/material.dart';

import '../services/app_session.dart';
import '../theme/wtr_theme.dart';
import '../widgets/common.dart';

/// Screen 3 — Enable Notifications bottom sheet.
Future<void> showEnableNotificationsSheet(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: paletteOf(context).card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      final p = paletteOf(ctx);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Grabber(),
              const SizedBox(height: 14),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: p.skeleton,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.notifications_none_outlined, color: p.ink, size: 40),
              ),
              const SizedBox(height: 18),
              Text('Enable Notifications',
                  style: TextStyle(
                      color: p.ink, fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  "Get important updates about your upcoming bookings, promos, and more. Tap 'Allow' on the following screen.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: p.muted, fontSize: 14, height: 1.5),
                ),
              ),
              const SizedBox(height: 26),
              PillButton(
                label: 'Okay',
                onTap: () {
                  Navigator.of(ctx).pop();
                  session.setNotifications(true);
                  _toast(context, 'Notifications on (demo)');
                },
              ),
              TextLink(
                label: 'Dismiss',
                centered: true,
                onTap: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _toast(BuildContext context, String msg) {
  final p = paletteOf(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      backgroundColor: p.card,
    ),
  );
}
