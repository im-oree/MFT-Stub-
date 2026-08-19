import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/wtr_theme.dart';
import '../util/format.dart';

/// White/surface rounded card with a hairline border + subtle shadow.
class SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double radius;
  final bool bordered;

  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.radius = 16,
    this.bordered = true,
  });

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return Material(
      color: p.card,
      borderRadius: BorderRadius.circular(radius),
      elevation: bordered ? 0.4 : 0,
      shadowColor: Colors.black.withAlpha(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          decoration: bordered
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(color: p.border),
                )
              : null,
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsets padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.padding = const EdgeInsets.fromLTRB(20, 4, 20, 12),
  });

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Text(title,
              style: TextStyle(
                  color: p.ink, fontSize: 18, fontWeight: FontWeight.w800)),
          const Spacer(),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: p.ink,
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(actionLabel!,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            ),
        ],
      ),
    );
  }
}

enum PillStyle { solid, outline }

/// The site-wide primary/secondary action button (solid black pill / white outline pill).
class PillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final PillStyle style;
  final bool expanded;
  final IconData? icon;
  final bool loading;
  final double height;

  const PillButton({
    super.key,
    required this.label,
    this.onTap,
    this.style = PillStyle.solid,
    this.expanded = true,
    this.icon,
    this.loading = false,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    final disabled = onTap == null && !loading;
    final solid = style == PillStyle.solid;
    final bg = solid ? p.block : Colors.transparent;
    final fg = solid ? p.onBlock : p.ink;
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(height / 2),
        child: InkWell(
          onTap: loading ? null : onTap,
          borderRadius: BorderRadius.circular(height / 2),
          child: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.center,
            decoration: solid
                ? null
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(height / 2),
                    border: Border.all(color: p.ink, width: 1.4),
                  ),
            child: loading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: fg),
                  )
                : Row(
                    mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: fg, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Text(label,
                          style: TextStyle(
                              color: fg,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Plain text link / button (e.g. "Dismiss", "View full schedule").
class TextLink extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool centered;
  final FontWeight weight;
  const TextLink({
    super.key,
    required this.label,
    this.onTap,
    this.centered = false,
    this.weight = FontWeight.w700,
  });

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Align(
          alignment: centered ? Alignment.center : Alignment.centerLeft,
          child: Text(label,
              style: TextStyle(
                  color: p.ink, fontSize: 15, fontWeight: weight)),
        ),
      ),
    );
  }
}

/// The black/white block header used at the top of most screens.
/// Flat-bottomed by default; pass `curved: true` for the Profile screen.
class BlockHeader extends StatelessWidget {
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final bool curved;
  final EdgeInsets padding;

  const BlockHeader({
    super.key,
    this.titleWidget,
    this.leading,
    this.actions,
    this.curved = false,
    this.padding = const EdgeInsets.fromLTRB(20, 14, 16, 24),
  });

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return Container(
      decoration: BoxDecoration(
        color: p.block,
        borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(curved ? 28 : 0)),
      ),
      child: SafeArea(
        bottom: false,
        child: DefaultTextStyle(
          style: TextStyle(color: p.onBlock),
          child: Padding(
            padding: padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (leading != null) leading!,
                if (titleWidget != null)
                  Expanded(child: titleWidget!)
                else
                  const Spacer(),
                if (actions != null) ...actions!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Circular soccer-ball badge for session rows.
class SoccerBadge extends StatelessWidget {
  final double size;
  const SoccerBadge({super.key, this.size = 44});

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: p.block, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Icon(Icons.sports_soccer, color: p.onBlock, size: size * 0.5),
    );
  }
}

enum DateState { selected, secondary, normal }

/// One circle in the horizontal date selector.
class DateCircle extends StatelessWidget {
  final int day;
  final String label;
  final DateState state;
  final VoidCallback? onTap;

  const DateCircle({
    super.key,
    required this.day,
    required this.label,
    this.state = DateState.normal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    final selected = state == DateState.selected;
    final secondary = state == DateState.secondary;
    final circleColor = selected
        ? p.block
        : secondary
            ? p.skeleton
            : Colors.transparent;
    final numColor = selected
        ? p.onBlock
        : secondary
            ? p.muted
            : p.ink;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 52,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                  border: (!selected && !secondary)
                      ? Border.all(color: p.border, width: 1.2)
                      : null,
                ),
                alignment: Alignment.center,
                child: Text('$day',
                    style: TextStyle(
                        color: numColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 6),
              Text(label,
                  style: TextStyle(
                    color: selected ? p.ink : p.muted,
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

/// A divider-separated session row (Book list).
class SessionRow extends StatelessWidget {
  final SessionSlot slot;
  final VoidCallback? onTap;
  final bool showDivider;

  const SessionRow({
    super.key,
    required this.slot,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                const SoccerBadge(),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(slot.title,
                          style: TextStyle(
                              color: p.ink,
                              fontSize: 16,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 3),
                      Text(
                        '${timeOnTheHour(slot.start)} · ${slot.durationMin} min',
                        style: TextStyle(color: p.muted, fontSize: 13),
                      ),
                      const SizedBox(height: 3),
                      Text(slot.category,
                          style: TextStyle(color: p.muted, fontSize: 12)),
                    ],
                  ),
                ),
                if (slot.isFull)
                  _Tag('Full', color: p.muted)
                else if (slot.spotsLeft <= 3)
                  _Tag('${slot.spotsLeft} left', color: p.ink)
                else
                  Icon(Icons.chevron_right, color: p.muted),
              ],
            ),
          ),
          if (showDivider)
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(height: 1, color: p.divider),
            ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  const _Tag(this.text, {required this.color});

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: p.canvas,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w800)),
    );
  }
}

/// Divider-separated menu row (More / Settings lists).
class MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool showDivider;
  final Widget? trailing;

  const MenuRow({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.showDivider = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Icon(icon, color: p.ink, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(label,
                      style: TextStyle(
                          color: p.ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
                trailing ??
                    Icon(Icons.chevron_right, color: p.muted),
              ],
            ),
          ),
          if (showDivider)
            Padding(
              padding: const EdgeInsets.only(left: 56),
              child: Container(height: 1, color: p.divider),
            ),
        ],
      ),
    );
  }
}

class Grabber extends StatelessWidget {
  const Grabber({super.key});

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 6),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: p.muted.withAlpha(90),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

// ── Skeletons (loading placeholders) ───────────────────────────────────────

class Skeleton extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  const Skeleton(
      {super.key, this.width = double.infinity, this.height = 12, this.radius = 6});

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: p.skeleton, borderRadius: BorderRadius.circular(radius)),
    );
  }
}

class SkeletonCircle extends StatelessWidget {
  final double size;
  const SkeletonCircle({super.key, this.size = 44});
  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: p.skeleton, shape: BoxShape.circle),
    );
  }
}

/// Horizontal progress bar (e.g. capacity fill).
class Bar extends StatelessWidget {
  final double fraction;
  final Color? color;
  final double height;
  const Bar({super.key, required this.fraction, this.color, this.height = 8});

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: height,
        color: p.skeleton,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: fraction.clamp(0.02, 1.0).toDouble(),
            child: Container(
              decoration: BoxDecoration(
                color: color ?? p.ink,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String title;
  final String? body;
  final IconData icon;
  const EmptyState({super.key, required this.title, this.body, this.icon = Icons.inbox_outlined});

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(icon, color: p.muted, size: 40),
          const SizedBox(height: 14),
          Text(title,
              style: TextStyle(color: p.ink, fontSize: 16, fontWeight: FontWeight.w700)),
          if (body != null) ...[
            const SizedBox(height: 6),
            Text(body!,
                textAlign: TextAlign.center,
                style: TextStyle(color: p.muted, fontSize: 13, height: 1.4)),
          ],
        ],
      ),
    );
  }
}

/// Mimics the Book list while slots load.
class SkeletonSessionList extends StatelessWidget {
  final int count;
  const SkeletonSessionList({super.key, this.count = 4});
  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return Column(
      children: [
        for (var i = 0; i < count; i++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                const SkeletonCircle(),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Skeleton(width: 140, height: 14),
                      const SizedBox(height: 8),
                      Skeleton(width: 180 + (i * 10.0), height: 11),
                      const SizedBox(height: 8),
                      const Skeleton(width: 90, height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(height: 1, color: p.divider),
          ),
        ],
      ],
    );
  }
}
