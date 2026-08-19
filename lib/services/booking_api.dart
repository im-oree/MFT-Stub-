import '../data/mock_data.dart';
import '../models/models.dart';

/// Thrown by the mock auth flow.
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}

/// Async data access for the app.
///
/// Every method returns a Future with a small artificial delay to simulate
/// network latency (and to exercise the loading skeletons). **To go live**,
/// keep these signatures and replace the bodies with real HTTP calls
/// (`package:dio` / `http`), pointing at your booking backend. The rest of the
/// app consumes this single object and does not touch `MockData` directly.
class BookingApi {
  const BookingApi();

  Future<void> _delay({int ms = 600}) => Future.delayed(Duration(milliseconds: ms));

  Future<List<CityLocation>> getCities() async {
    await _delay();
    return MockData.cities;
  }

  Future<List<SessionSlot>> getSlots(String cityId, DateTime day) async {
    await _delay();
    return MockData.slotsForCity(cityId, day);
  }

  Future<List<MembershipPlan>> getPlans() async {
    await _delay();
    return MockData.plans;
  }

  Future<AppUser> signIn({required String email, required String password}) async {
    await _delay();
    if (email.trim().isEmpty) throw const AuthException('Enter your email');
    if (password.isEmpty) throw const AuthException('Enter your password');
    // Mock: any well-formed login resolves to the sample member account.
    return MockData.sampleUser.copyWith(email: email.trim());
  }

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _delay();
    if (name.trim().isEmpty) throw const AuthException('Enter your name');
    if (email.trim().isEmpty) throw const AuthException('Enter your email');
    if (password.length < 6) throw const AuthException('Password must be at least 6 characters');
    return MockData.sampleUser.copyWith(name: name.trim(), email: email.trim());
  }

  Future<Booking> book(String userId, SessionSlot slot) async {
    await _delay(ms: 800);
    if (slot.isFull) throw const AuthException('That session just filled up');
    return Booking(
      id: 'b-${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      slot: slot.copyWith(booked: slot.booked + 1),
      createdAt: DateTime.now(),
      status: BookingStatus.confirmed,
    );
  }

  Future<List<AppNotification>> getNotifications() async {
    await _delay();
    return MockData.notifications;
  }
}

/// Single shared instance consumed across the app.
final api = const BookingApi();
