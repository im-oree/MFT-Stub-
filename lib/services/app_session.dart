import 'package:flutter/foundation.dart';

import '../data/mock_data.dart';
import '../models/models.dart';
import 'booking_api.dart';
import 'package:flutter/material.dart' show ThemeMode;

/// App-wide observable state: auth, selected city, bookings, and settings.
///
/// Listen with `AnimatedBuilder(animation: session, builder: ...)` so the UI
/// rebuilds when auth state, bookings, or the theme toggle change.
class AppSession extends ChangeNotifier {
  AppSession();

  bool _signedIn = false;
  AppUser? _user;
  CityLocation _city = MockData.cities.first;
  final List<Booking> _bookings = [];
  bool _dark = false;
  bool _notificationsEnabled = false;

  bool get isSignedIn => _signedIn;
  AppUser? get user => _user;
  CityLocation get city => _city;
  List<Booking> get bookings => List.unmodifiable(_bookings);
  bool get dark => _dark;
  bool get notificationsEnabled => _notificationsEnabled;
  ThemeMode get themeMode => _dark ? ThemeMode.dark : ThemeMode.light;

  List<Booking> upcomingBookings(DateTime now) => _bookings
      .where((b) => b.slot.start.isAfter(now) && b.status == BookingStatus.confirmed)
      .toList()
    ..sort((a, b) => a.slot.start.compareTo(b.slot.start));

  Future<void> signIn({required String email, required String password}) async {
    _user = await api.signIn(email: email, password: password);
    _signedIn = true;
    notifyListeners();
  }

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = await api.register(name: name, email: email, password: password);
    _user = user;
    _signedIn = true;
    notifyListeners();
    return user;
  }

  void signOut() {
    _signedIn = false;
    _user = null;
    notifyListeners();
  }

  void setCity(CityLocation city) {
    _city = city;
    notifyListeners();
  }

  Future<Booking> book(SessionSlot slot) async {
    final booking = await api.book(_user!.id, slot);
    _bookings.insert(0, booking);
    notifyListeners();
    return booking;
  }

  void cancelBooking(String id) {
    final i = _bookings.indexWhere((b) => b.id == id);
    if (i >= 0) {
      _bookings.removeAt(i);
      notifyListeners();
    }
  }

  void toggleTheme() {
    _dark = !_dark;
    notifyListeners();
  }

  void setNotifications(bool enabled) {
    _notificationsEnabled = enabled;
    notifyListeners();
  }
}

/// Single shared instance.
final session = AppSession();
