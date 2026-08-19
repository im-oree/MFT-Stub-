import 'package:flutter/material.dart';

import '../services/app_session.dart';
import '../theme/wtr_theme.dart';
import '../widgets/common.dart';
import 'enable_notifications_sheet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: session,
      builder: (context, _) {
        final p = paletteOf(context);
        return Scaffold(
          backgroundColor: p.bg,
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            children: [
              _section(context, 'Appearance'),
              _switchRow(context, 'Dark mode', session.dark, (v) => session.toggleTheme()),
              _divider(context),
              _section(context, 'Notifications'),
              _switchRow(context, 'Push notifications', session.notificationsEnabled, (v) {
                if (v) {
                  showEnableNotificationsSheet(context);
                } else {
                  session.setNotifications(false);
                }
              }),
              _divider(context),
              _section(context, 'Account'),
              if (session.isSignedIn) ...[
                _staticRow(context, Icons.mail_outline, session.user?.email ?? ''),
                MenuRow(
                  icon: Icons.logout,
                  label: 'Sign out',
                  showDivider: false,
                  onTap: () => session.signOut(),
                ),
              ] else
                _staticRow(context, Icons.info_outline, 'Sign in to manage your account.'),
            ],
          ),
        );
      },
    );
  }

  Widget _section(BuildContext context, String title) {
    final p = paletteOf(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 6),
      child: Text(title.toUpperCase(),
          style: TextStyle(
              color: p.muted, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.6)),
    );
  }

  Widget _switchRow(BuildContext context, String title, bool value, ValueChanged<bool> onChanged) {
    final p = paletteOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(title,
                style: TextStyle(color: p.ink, fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _staticRow(BuildContext context, IconData icon, String text) {
    final p = paletteOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: p.ink),
          const SizedBox(width: 14),
          Expanded(
              child: Text(text,
                  style: TextStyle(color: p.ink, fontSize: 15, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    final p = paletteOf(context);
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Container(height: 1, color: p.divider),
    );
  }
}
