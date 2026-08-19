import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/models.dart';
import '../services/app_session.dart';
import '../services/booking_api.dart';
import '../theme/wtr_theme.dart';
import '../util/format.dart';
import '../widgets/common.dart';
import 'location_picker_screen.dart';
import 'sign_in_screen.dart';

/// Screen 4 — Home (signed-in / loaded state).
class HomeScreen extends StatefulWidget {
  final VoidCallback onBook;
  const HomeScreen({super.key, required this.onBook});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SessionSlot>? _upcoming;
  String? _cityId;

  @override
  void initState() {
    super.initState();
    session.addListener(_onSessionChanged);
    _load();
  }

  @override
  void dispose() {
    session.removeListener(_onSessionChanged);
    super.dispose();
  }

  void _onSessionChanged() {
    if (session.city.id != _cityId) _load();
  }

  Future<void> _load() async {
    _cityId = session.city.id;
    final slots = await api.getSlots(session.city.id, MockData.today);
    if (!mounted) return;
    setState(() => _upcoming = slots.take(3).toList());
  }

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return Scaffold(
      backgroundColor: p.bg,
      body: Column(
        children: [
          BlockHeader(
            titleWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  session.isSignedIn
                      ? 'Welcome back to'
                      : 'Welcome to',
                  style: TextStyle(
                    color: p.onBlock.withAlpha(190),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  session.city.name,
                  style: TextStyle(
                    color: p.onBlock,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.location_on_outlined, color: p.onBlock),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 20, bottom: 28),
              children: [
                _infoCard(context),
                const SectionHeader(title: 'Coming up'),
                _comingUpCard(context),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: PillButton(
                    label: session.isSignedIn ? 'Book a session' : 'Sign in to book',
                    icon:
                        session.isSignedIn ? Icons.calendar_today : Icons.lock_outline,
                    onTap: () {
                      if (session.isSignedIn) {
                        widget.onBook();
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SignInScreen()),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(BuildContext context) {
    final p = paletteOf(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: p.canvas,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome To The Roof!',
              style: TextStyle(
                color: p.ink,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Book rooftop pickup soccer in minutes. Drop in for a session, or go '
              'unlimited with a membership — we sort the court, the opponents, and '
              'the vibes.',
              style: TextStyle(color: p.ink.withAlpha(200), fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _comingUpCard(BuildContext context) {
    final p = paletteOf(context);
    final loading = _upcoming == null;
    final count = loading ? 3 : _upcoming!.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SurfaceCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            for (var i = 0; i < count; i++) ...[
              if (loading) _skeletonRow(context) else _comingUpRow(context, _upcoming![i]),
              if (i < count - 1)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(height: 1, color: p.divider),
                ),
            ],
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Container(height: 1, color: p.divider),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onBook,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'View full schedule',
                  style: TextStyle(
                    color: p.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _comingUpRow(BuildContext context, SessionSlot slot) {
    final p = paletteOf(context);
    return InkWell(
      onTap: widget.onBook,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(slot.title,
                      style: TextStyle(
                          color: p.ink, fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(slotLine(slot.start),
                      style: TextStyle(color: p.muted, fontSize: 13)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: p.muted),
          ],
        ),
      ),
    );
  }

  Widget _skeletonRow(BuildContext context) {
    final p = paletteOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Skeleton(width: 130, height: 14),
          const SizedBox(height: 8),
          const Skeleton(width: 180, height: 11),
        ],
      ),
    );
  }
}
