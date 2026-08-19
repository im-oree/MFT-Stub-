import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/models.dart';
import '../services/app_session.dart';
import '../theme/wtr_theme.dart';
import '../util/format.dart';
import '../widgets/common.dart';
import 'booking_confirm_screen.dart';
import 'sign_in_screen.dart';

class SessionDetailScreen extends StatefulWidget {
  final SessionSlot slot;
  const SessionDetailScreen({super.key, required this.slot});

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  bool _booking = false;

  Future<void> _book() async {
    if (!session.isSignedIn) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const SignInScreen()));
      return;
    }
    setState(() => _booking = true);
    try {
      final booking = await session.book(widget.slot);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => BookingConfirmScreen(booking: booking)),
      );
    } catch (e) {
      if (!mounted) return;
      final p = paletteOf(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          behavior: SnackBarBehavior.floating,
          backgroundColor: p.card,
        ),
      );
    } finally {
      if (mounted) setState(() => _booking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    final slot = widget.slot;
    final venue = MockData.venueFor(slot.cityId);
    final fill = slot.booked / slot.capacity;
    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(title: const Text('Session')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SoccerBadge(size: 48),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(slot.title,
                                    style: TextStyle(
                                        color: p.ink,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800)),
                                const SizedBox(height: 2),
                                Text(slot.category,
                                    style: TextStyle(color: p.muted, fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _detailRow(context, Icons.event_outlined, longDate(slot.start)),
                      const SizedBox(height: 12),
                      _detailRow(
                          context, Icons.schedule_outlined, timeRange(slot.start, slot.durationMin)),
                      const SizedBox(height: 12),
                      _detailRow(context, Icons.signal_cellular_alt_outlined, slot.level ?? 'All levels'),
                      const SizedBox(height: 12),
                      _detailRow(context, Icons.attach_money, '${money(slot.priceCents)} / session'),
                      const SizedBox(height: 20),
                      Text('Spots',
                          style: TextStyle(
                              color: p.muted,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Bar(fraction: fill, color: p.ink),
                      const SizedBox(height: 8),
                      Text(
                        slot.isFull
                            ? 'Fully booked'
                            : '${slot.spotsLeft} of ${slot.capacity} spots left',
                        style: TextStyle(color: p.ink, fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SurfaceCard(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: p.ink),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(venue?.name ?? 'The Roof',
                                style: TextStyle(
                                    color: p.ink,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(height: 2),
                            Text(
                                '${session.city.name} · ${venue?.note ?? 'Rooftop'}',
                                style: TextStyle(color: p.muted, fontSize: 13)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: p.muted),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: p.bg,
              border: Border(top: BorderSide(color: p.divider)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: SafeArea(
              top: false,
              child: PillButton(
                loading: _booking,
                label: slot.isFull
                    ? 'Fully booked'
                    : session.isSignedIn
                        ? 'Book — ${money(slot.priceCents)}'
                        : 'Sign in to book',
                onTap: slot.isFull || _booking ? null : _book,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(BuildContext context, IconData icon, String text) {
    final p = paletteOf(context);
    return Row(
      children: [
        Icon(icon, color: p.ink, size: 20),
        const SizedBox(width: 12),
        Expanded(
            child:
                Text(text, style: TextStyle(color: p.ink, fontSize: 15, fontWeight: FontWeight.w600))),
      ],
    );
  }
}
