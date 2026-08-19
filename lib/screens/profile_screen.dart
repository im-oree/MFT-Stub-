import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/models.dart';
import '../services/app_session.dart';
import '../theme/wtr_theme.dart';
import '../util/format.dart';
import '../widgets/common.dart';
import 'create_account_screen.dart';
import 'session_detail_screen.dart';
import 'settings_screen.dart';
import 'sign_in_screen.dart';

/// Screen 1 — Profile. Signed-out shows the auth prompt; signed-in shows the
/// account, bookings, and settings entry.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return session.isSignedIn ? _signedIn(context) : _signedOut(context);
  }

  // ── Signed out ───────────────────────────────────────────────────────────
  Widget _signedOut(BuildContext context) {
    final p = paletteOf(context);
    return Scaffold(
      backgroundColor: p.bg,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _curvedHeader(context, child: _ringAvatar(context, icon: Icons.person)),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 32),
            child: Column(
              children: [
                Text('Sign in to see your profile',
                    style: TextStyle(
                        color: p.ink, fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 24),
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
        ],
      ),
    );
  }

  // ── Signed in ────────────────────────────────────────────────────────────
  Widget _signedIn(BuildContext context) {
    final p = paletteOf(context);
    final user = session.user!;
    final plan = session.user?.planId == null
        ? null
        : MockData.plans.firstWhere((pl) => pl.id == user.planId, orElse: () => MockData.plans.first);
    final upcoming = session.upcomingBookings(MockData.today);
    final initials = user.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join();

    return Scaffold(
      backgroundColor: p.bg,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _curvedHeader(
            context,
            child: _ringAvatar(context, initials: initials),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(user.name,
                          style: TextStyle(
                              color: p.ink, fontSize: 20, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 3),
                      Text(user.email, style: TextStyle(color: p.muted, fontSize: 13)),
                      if (plan != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: p.ink,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(plan.name,
                              style: TextStyle(
                                  color: p.onInk,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    _stat(context, '${session.bookings.length}', 'Bookings'),
                    const SizedBox(width: 28),
                    _stat(context, plan?.period.contains('month') == true ? 'Unlimited' : 'Drop-in', 'Plan'),
                  ],
                ),
                const SizedBox(height: 24),
                const SectionHeader(title: 'My bookings', padding: EdgeInsets.zero),
                const SizedBox(height: 4),
                if (upcoming.isEmpty)
                  EmptyState(
                    icon: Icons.event_available,
                    title: 'No upcoming bookings',
                    body: 'Head to the Book tab to reserve a session.',
                  )
                else
                  for (final b in upcoming) _bookingRow(context, b),
                const SizedBox(height: 8),
                MenuRow(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  ),
                ),
                MenuRow(
                  icon: Icons.logout,
                  label: 'Sign out',
                  showDivider: false,
                  onTap: () => session.signOut(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String value, String label) {
    final p = paletteOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: TextStyle(color: p.ink, fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: p.muted, fontSize: 12)),
      ],
    );
  }

  Widget _bookingRow(BuildContext context, Booking b) {
    final p = paletteOf(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SurfaceCard(
        padding: const EdgeInsets.all(12),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => SessionDetailScreen(slot: b.slot)),
        ),
        child: Row(
          children: [
            const SoccerBadge(size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b.slot.title,
                      style: TextStyle(
                          color: p.ink, fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(slotLine(b.slot.start),
                      style: TextStyle(color: p.muted, fontSize: 13)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _confirmCancel(context, b.id),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Text('Cancel',
                    style: TextStyle(
                        color: p.muted, fontSize: 13, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmCancel(BuildContext context, String id) {
    final p = paletteOf(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: p.card,
        title: Text('Cancel booking?', style: TextStyle(color: p.ink)),
        content: Text('Free up your spot. You can rebook anytime.',
            style: TextStyle(color: p.muted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Keep', style: TextStyle(color: p.ink)),
          ),
          TextButton(
            onPressed: () {
              session.cancelBooking(id);
              Navigator.of(ctx).pop();
            },
            child: Text('Cancel booking', style: TextStyle(color: p.ink)),
          ),
        ],
      ),
    );
  }

  // ── Shared curved header + avatar ────────────────────────────────────────
  Widget _curvedHeader(BuildContext context, {required Widget child}) {
    final p = paletteOf(context);
    return Container(
      decoration: BoxDecoration(
        color: p.block,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 46),
          child: Center(child: child),
        ),
      ),
    );
  }

  Widget _ringAvatar(BuildContext context, {IconData? icon, String? initials}) {
    final p = paletteOf(context);
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: p.skeleton,
        border: Border.all(color: p.onBlock, width: 4),
      ),
      alignment: Alignment.center,
      child: initials != null
          ? Text(initials,
              style: TextStyle(
                  color: p.ink, fontSize: 30, fontWeight: FontWeight.w800))
          : Icon(icon ?? Icons.person, color: p.muted, size: 42),
    );
  }
}
