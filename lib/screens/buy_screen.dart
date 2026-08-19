import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/app_session.dart';
import '../services/booking_api.dart';
import '../theme/wtr_theme.dart';
import '../util/format.dart';
import '../widgets/common.dart';
import 'create_account_screen.dart';

/// Buy — membership plans (a screen not in the reference set; designed to match).
class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  List<MembershipPlan>? _plans;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final plans = await api.getPlans();
    if (!mounted) return;
    setState(() => _plans = plans);
  }

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return Scaffold(
      backgroundColor: p.bg,
      body: Column(
        children: [
          BlockHeader(
            titleWidget: Text('Membership',
                style: TextStyle(
                    color: p.onBlock, fontSize: 24, fontWeight: FontWeight.w800)),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              children: [
                Text(
                  'Unlimited rooftop pickup, one flat membership. Cancel anytime.',
                  style: TextStyle(color: p.ink.withAlpha(200), fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 18),
                if (_plans == null)
                  for (var i = 0; i < 3; i++) ...[
                    _planSkeleton(context),
                    const SizedBox(height: 14),
                  ]
                else
                  for (final plan in _plans!) ...[
                    _planCard(context, plan),
                    const SizedBox(height: 14),
                  ],
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'Billed by The Roof. Cancel anytime.',
                    style: TextStyle(color: p.muted, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _planSkeleton(BuildContext context) {
    final p = paletteOf(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(width: 150, height: 18),
          SizedBox(height: 14),
          Skeleton(width: 90, height: 26),
          SizedBox(height: 16),
          Skeleton(width: double.infinity, height: 12),
          SizedBox(height: 10),
          Skeleton(width: 220, height: 12),
        ],
      ),
    );
  }

  Widget _planCard(BuildContext context, MembershipPlan plan) {
    final p = paletteOf(context);
    final isCurrent = session.isSignedIn && session.user?.planId == plan.id;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: plan.featured ? p.ink : p.border, width: plan.featured ? 1.6 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(plan.name,
                    style: TextStyle(
                        color: p.ink, fontSize: 18, fontWeight: FontWeight.w800)),
              ),
              if (plan.featured)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: p.ink,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text('Most popular',
                      style: TextStyle(color: p.onInk, fontSize: 11, fontWeight: FontWeight.w800)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(money(plan.priceCents),
                  style: TextStyle(
                      color: p.ink, fontSize: 30, fontWeight: FontWeight.w800)),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(plan.period,
                    style: TextStyle(color: p.muted, fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (final perk in plan.perks) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(Icons.check, color: p.ink, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(perk,
                      style: TextStyle(color: p.ink.withAlpha(210), fontSize: 14, height: 1.4)),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
          PillButton(
            label: isCurrent ? 'Current plan' : 'Join ${plan.name}',
            style: plan.featured ? PillStyle.solid : PillStyle.outline,
            onTap: isCurrent ? null : () => _join(context, plan),
          ),
        ],
      ),
    );
  }

  void _join(BuildContext context, MembershipPlan plan) {
    if (!session.isSignedIn) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
      );
      return;
    }
    final p = paletteOf(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("You're on ${plan.name} (demo)"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.card,
      ),
    );
  }
}
