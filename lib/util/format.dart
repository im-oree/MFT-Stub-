/// Money / date / time formatting helpers (no `intl` package — kept dependency-free).

const _weekdayShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _weekdayLong = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
];
const _monthShort = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

String money(int cents) {
  final dollars = cents / 100;
  if (dollars == dollars.roundToDouble()) return '\$${dollars.round()}';
  return '\$${dollars.toStringAsFixed(2)}';
}

String hhmm(int hour) => '${hour.toString().padLeft(2, '0')}:00';

String timeOnTheHour(DateTime t, {String tz = 'GMT-05:00'}) =>
    '${hhmm(t.hour)} $tz';

String timeRange(DateTime start, int minutes, {String tz = 'GMT-05:00'}) {
  final end = start.add(Duration(minutes: minutes));
  return '${hhmm(start.hour)}–${hhmm(end.hour)} $tz';
}

String weekdayShort(DateTime d) => _weekdayShort[d.weekday - 1];
String weekdayLong(DateTime d) => _weekdayLong[d.weekday - 1];
String monthDay(DateTime d) => '${_monthShort[d.month - 1]} ${d.day}';
String longDate(DateTime d) => '${weekdayLong(d)}, ${monthDay(d)}'; // "Monday, Aug 10"

/// "Mon, Aug 10 · 19:00 GMT-05:00"
String slotLine(DateTime start, {String tz = 'GMT-05:00'}) =>
    '${weekdayShort(start)}, ${monthDay(start)} · ${timeOnTheHour(start, tz: tz)}';

String relativeTime(DateTime d, DateTime now) {
  final diff = now.difference(d);
  if (diff.isNegative) return 'soon';
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inHours < 1) return '${diff.inMinutes}m ago';
  if (diff.inDays < 1) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return monthDay(d);
}
