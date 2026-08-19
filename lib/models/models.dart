/// Domain models for the Welcome To The Roof booking app.

class CityLocation {
  final String id;
  final String name;
  final String region;
  const CityLocation({required this.id, required this.name, required this.region});
}

class Venue {
  final String id;
  final String name;
  final String cityId;
  final String? note;
  const Venue({required this.id, required this.name, required this.cityId, this.note});
}

/// A bookable pickup session slot.
class SessionSlot {
  final String id;
  final String venueId;
  final String cityId;
  final DateTime start;
  final int durationMin;
  final String title;
  final String category;
  final int capacity;
  final int booked;
  final int priceCents;
  final String? level;

  const SessionSlot({
    required this.id,
    required this.venueId,
    required this.cityId,
    required this.start,
    this.durationMin = 60,
    required this.title,
    required this.category,
    this.capacity = 12,
    this.booked = 0,
    this.priceCents = 1500,
    this.level,
  });

  DateTime get end => start.add(Duration(minutes: durationMin));
  int get spotsLeft => capacity - booked;
  bool get isFull => spotsLeft <= 0;

  SessionSlot copyWith({int? booked}) => SessionSlot(
        id: id,
        venueId: venueId,
        cityId: cityId,
        start: start,
        durationMin: durationMin,
        title: title,
        category: category,
        capacity: capacity,
        booked: booked ?? this.booked,
        priceCents: priceCents,
        level: level,
      );
}

class MembershipPlan {
  final String id;
  final String name;
  final int priceCents;
  final String period; // "/ month", "/ session", "one-time"
  final List<String> perks;
  final bool featured;
  const MembershipPlan({
    required this.id,
    required this.name,
    required this.priceCents,
    required this.period,
    this.perks = const [],
    this.featured = false,
  });
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? planId;
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.planId,
  });

  AppUser copyWith({String? name, String? email, String? phone, String? planId}) => AppUser(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        planId: planId ?? this.planId,
      );
}

enum BookingStatus { confirmed, completed, cancelled }

class Booking {
  final String id;
  final String userId;
  final SessionSlot slot;
  final DateTime createdAt;
  final BookingStatus status;
  const Booking({
    required this.id,
    required this.userId,
    required this.slot,
    required this.createdAt,
    this.status = BookingStatus.confirmed,
  });
}

enum NotificationKind { booking, promo, reminder, system }

class AppNotification {
  final String id;
  final NotificationKind kind;
  final String title;
  final String body;
  final DateTime at;
  final bool read;
  const AppNotification({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.at,
    this.read = false,
  });
}
