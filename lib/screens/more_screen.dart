import 'package:flutter/material.dart';

import '../services/app_session.dart';
import '../theme/wtr_theme.dart';
import '../widgets/common.dart';
import 'create_account_screen.dart';
import 'location_picker_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';
import 'sign_in_screen.dart';

/// Screen 2 — More. Signed-out shows the auth buttons; signed-in adds sign-out.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return Scaffold(
      backgroundColor: p.bg,
      body: Column(
        children: [
          BlockHeader(
            titleWidget: Text('More',
                style: TextStyle(
                    color: p.onBlock, fontSize: 24, fontWeight: FontWeight.w800)),
            actions: [
              IconButton(
                icon: Icon(Icons.location_on_outlined, color: p.onBlock),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
                ),
              ),
            ],
          ),
          Container(
            color: p.card,
            child: Column(
              children: [
                MenuRow(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  ),
                ),
                MenuRow(
                  icon: Icons.mail_outline,
                  label: 'Contact Us',
                  onTap: () => _toast(context, 'Contact us (demo)'),
                ),
                MenuRow(
                  icon: Icons.notifications_none_outlined,
                  label: 'Recent Notifications',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                  ),
                ),
                MenuRow(
                  icon: Icons.help_outline,
                  label: 'Help Center',
                  showDivider: !session.isSignedIn,
                  onTap: () => _toast(context, 'Help center (demo)'),
                ),
                if (session.isSignedIn)
                  MenuRow(
                    icon: Icons.logout,
                    label: 'Sign out',
                    showDivider: false,
                    onTap: () => session.signOut(),
                  ),
              ],
            ),
          ),
          if (!session.isSignedIn)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              child: Column(
                children: [
                  PillButton(
                    label: 'Sign in',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SignInScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  PillButton(
                    label: 'Create an account',
                    style: PillStyle.outline,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(child: Container(color: p.canvas)),
        ],
      ),
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
}
