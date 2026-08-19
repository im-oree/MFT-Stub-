import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/models.dart';
import '../services/app_session.dart';
import '../services/booking_api.dart';
import '../theme/wtr_theme.dart';
import '../util/format.dart';
import '../widgets/common.dart';
import 'enable_notifications_sheet.dart';
import 'location_picker_screen.dart';
import 'session_detail_screen.dart';

/// Screen 5 — Book (loaded schedule). Loading state mirrors Screen 3's skeleton.
class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  late final List<DateTime> _days;
  int _selected = 0;
  List<SessionSlot>? _slots;
  bool _loading = true;
  String? _cityId;
  static bool _notificationsPrompted = false;

  @override
  void initState() {
    super.initState();
    _days = [for (var i = 0; i < 7; i++) MockData.today.add(Duration(days: i))];
    session.addListener(_onSessionChanged);
    _load();
    if (!session.notificationsEnabled && !_notificationsPrompted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _notificationsPrompted = true;
        showEnableNotificationsSheet(context);
      });
    }
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
    if (!mounted) return;
    setState(() => _loading = true);
    _cityId = session.city.id;
    final day = _days[_selected];
    final slots = await api.getSlots(session.city.id, day);
    if (!mounted) return;
    setState(() {
      _slots = slots;
      _loading = false;
    });
  }

  void _selectDay(int i) {
    if (i == _selected) return;
    setState(() => _selected = i);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return Scaffold(
      backgroundColor: p.bg,
      body: Column(
        children: [
          BlockHeader(
            leading: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on_outlined, color: p.onBlock, size: 20),
                  const SizedBox(width: 6),
                  Text(session.city.name,
                      style: TextStyle(
                          color: p.onBlock,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(width: 2),
                  Icon(Icons.expand_more, color: p.onBlock),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.calendar_today_outlined, color: p.onBlock, size: 22),
                onPressed: () => _toast(context, 'Calendar picker (demo)'),
              ),
              IconButton(
                icon: Icon(Icons.tune_outlined, color: p.onBlock, size: 22),
                onPressed: () => _toast(context, 'Filters (demo)'),
              ),
            ],
          ),
          _dateRow(context),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(longDate(_days[_selected]),
                  style: TextStyle(
                      color: p.ink, fontSize: 20, fontWeight: FontWeight.w800)),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: p.ink,
              onRefresh: _load,
              child: _loading || _slots == null
                  ? ListView(children: const [SkeletonSessionList()])
                  : _slots!.isEmpty
                      ? ListView(children: [
                          EmptyState(
                            icon: Icons.event_busy,
                            title: 'No sessions this day',
                            body: 'Pick another date or check back soon.',
                          )
                        ])
                      : ListView.builder(
                          itemCount: _slots!.length,
                          itemBuilder: (context, i) => SessionRow(
                            slot: _slots![i],
                            showDivider: i < _slots!.length - 1,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SessionDetailScreen(slot: _slots![i]),
                              ),
                            ),
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateRow(BuildContext context) {
    final p = paletteOf(context);
    return Container(
      color: p.bg,
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
      child: SizedBox(
        height: 86,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _days.length,
          separatorBuilder: (_, __) => const SizedBox(width: 2),
          itemBuilder: (context, i) {
            final d = _days[i];
            final state = i == _selected
                ? DateState.selected
                : (i == 3 ? DateState.secondary : DateState.normal);
            return DateCircle(
              day: d.day,
              label: i == 0 ? 'Today' : weekdayShort(d),
              state: state,
              onTap: () => _selectDay(i),
            );
          },
        ),
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
