import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/models.dart';
import '../services/app_session.dart';
import '../theme/wtr_theme.dart';
import '../util/format.dart';
import '../widgets/common.dart';

/// Booking success screen.
class BookingConfirmScreen extends StatelessWidget {
  final Booking booking;
  const BookingConfirmScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    final slot = booking.slot;
    return Scaffold(
      backgroundColor: p.bg,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: p.block,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: p.onBlock,
                        ),
                        alignment: Alignment.center,
                        child: Icon(Icons.check, color: p.block, size: 40),
                      ),
                      const SizedBox(height: 18),
                      Text("You're booked!",
                          style: TextStyle(
                              color: p.onBlock,
                              fontSize: 24,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(
                        'Confirmation sent to ${session.user?.email ?? 'your email'}',
                        style: TextStyle(color: p.onBlock.withAlpha(190), fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SoccerBadge(size: 44),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(slot.title,
                                    style: TextStyle(
                                        color: p.ink,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800)),
                                const SizedBox(height: 2),
                                Text(slotLine(slot.start),
                                    style: TextStyle(color: p.muted, fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(height: 1, color: p.divider),
                      const SizedBox(height: 14),
                      _row(context, Icons.schedule_outlined,
                          timeRange(slot.start, slot.durationMin)),
                      const SizedBox(height: 10),
                      _row(context, Icons.location_on_outlined,
                          MockData.venueFor(slot.cityId)?.name ?? 'The Roof'),
                      const SizedBox(height: 10),
                      _row(context, Icons.confirmation_number_outlined, 'Booking #${booking.id.substring(2, 8)}'),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                PillButton(
                  label: 'Add to calendar',
                  style: PillStyle.outline,
                  icon: Icons.calendar_today_outlined,
                  onTap: () => _toast(context, 'Added to calendar (demo)'),
                ),
                const SizedBox(height: 12),
                PillButton(
                  label: 'Done',
                  onTap: () => Navigator.of(context)
                      .popUntil((route) => route.isFirst),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, String text) {
    final p = paletteOf(context);
    return Row(
      children: [
        Icon(icon, color: p.ink, size: 20),
        const SizedBox(width: 12),
        Expanded(
            child: Text(text,
                style: TextStyle(color: p.ink, fontSize: 14, fontWeight: FontWeight.w600))),
      ],
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
