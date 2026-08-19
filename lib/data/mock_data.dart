import '../models/models.dart';

/// Static seed data for the prototype. All values are illustrative.
///
/// In production this layer is replaced by real API calls — see
/// `services/booking_api.dart`.
class MockData {
  MockData._();

  /// The demo "today". Anchored to Monday Aug 10 2026 so the Book screen's
  /// date selector matches the design reference (10–16, "10" = Today).
  static final DateTime today = DateTime(2026, 8, 10);
  static const String tz = 'GMT-05:00';

  static const cities = [
    CityLocation(id: 'city-dal', name: 'Dallas', region: 'TX'),
    CityLocation(id: 'city-aus', name: 'Austin', region: 'TX'),
    CityLocation(id: 'city-hou', name: 'Houston', region: 'TX'),
    CityLocation(id: 'city-ftw', name: 'Fort Worth', region: 'TX'),
  ];

  static const venues = [
    Venue(id: 'v-dal', name: 'The Roof — Dallas', cityId: 'city-dal', note: 'Rooftop'),
    Venue(id: 'v-aus', name: 'The Roof — Austin', cityId: 'city-aus', note: 'Rooftop'),
    Venue(id: 'v-hou', name: 'The Roof — Houston', cityId: 'city-hou', note: 'Rooftop'),
    Venue(id: 'v-ftw', name: 'The Roof — Fort Worth', cityId: 'city-ftw', note: 'Rooftop'),
  ];

  static Venue? venueFor(String cityId) {
    for (final v in venues) {
      if (v.cityId == cityId) return v;
    }
    return null;
  }

  static const plans = [
    MembershipPlan(
      id: 'plan-drop',
      name: 'Drop-In',
      priceCents: 1500,
      period: '/ session',
      perks: ['Book any single session', 'Cancel up to 2h before', 'No commitment'],
    ),
    MembershipPlan(
      id: 'plan-unlimited',
      name: 'Rooftop Unlimited',
      priceCents: 8900,
      period: '/ month',
      perks: [
        'Unlimited rooftop sessions',
        'Priority booking 7 days out',
        'Bring a friend once a month',
        'Skip the line',
      ],
      featured: true,
    ),
    MembershipPlan(
      id: 'plan-10pack',
      name: '10-Session Pack',
      priceCents: 12000,
      period: 'one-time',
      perks: ['10 sessions to use anytime', 'Shareable with a teammate', 'Valid for 6 months', 'Save ~20%'],
    ),
  ];

  /// 7 days × 4 sessions/day × every city.
  static final List<SessionSlot> slots = _buildSlots();

  static List<SessionSlot> _buildSlots() {
    const hours = [19, 20, 21, 22];
    final list = <SessionSlot>[];
    var id = 0;
    for (final city in cities) {
      final venue = venueFor(city.id)!;
      for (var d = 0; d < 7; d++) {
        final day = today.add(Duration(days: d));
        for (var di = 0; di < hours.length; di++) {
          final h = hours[di];
          final start = DateTime(day.year, day.month, day.day, h);
          final cap = 12;
          // Deterministic, varied fill levels — make one late slot full.
          final seed = (city.id.hashCode ^ (d * 31 + h)).abs();
          int booked = seed % 8;
          if (di == hours.length - 1 && d == 0 && city.id == 'city-dal') booked = cap; // full
          booked = booked.clamp(0, cap).toInt();
          list.add(SessionSlot(
            id: 'slot-$id',
            venueId: venue.id,
            cityId: city.id,
            start: start,
            durationMin: 60,
            title: 'Pickup Soccer',
            category: 'Pickup Soccer',
            capacity: cap,
            booked: booked,
            priceCents: 1500,
            level: h <= 20 ? 'All levels' : 'Intermediate+',
          ));
          id++;
        }
      }
    }
    return list;
  }

  static List<SessionSlot> slotsForCity(String cityId, DateTime day) {
    return slots
        .where((s) =>
            s.cityId == cityId &&
            s.start.year == day.year &&
            s.start.month == day.month &&
            s.start.day == day.day)
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));
  }

  static const sampleUser = AppUser(
    id: 'u-1',
    name: 'Alex Rivera',
    email: 'alex@example.com',
    phone: '+1 214 555 0142',
    planId: 'plan-unlimited',
  );

  static final notifications = [
    AppNotification(
      id: 'n1',
      kind: NotificationKind.booking,
      title: "You're booked for Monday",
      body: 'Pickup Soccer · 19:00 GMT-05:00',
      at: today.subtract(const Duration(hours: 3)),
    ),
    AppNotification(
      id: 'n2',
      kind: NotificationKind.promo,
      title: 'Members: bring a friend free',
      body: 'Rooftop Unlimited perk — this month only',
      at: today.subtract(const Duration(days: 1)),
    ),
    AppNotification(
      id: 'n3',
      kind: NotificationKind.reminder,
      title: 'Your session starts in 2 hours',
      body: 'The Roof — Dallas · 20:00',
      at: today.subtract(const Duration(hours: 5)),
    ),
    AppNotification(
      id: 'n4',
      kind: NotificationKind.system,
      title: 'Welcome to The Roof',
      body: 'Book your first pickup session',
      at: today.subtract(const Duration(days: 2)),
    ),
  ];
}
