import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/booking_model.dart';
import '../models/service_model.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';

class BookingProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  final _uuid = const Uuid();

  List<Booking> _bookings = [];
  List<Booking> get bookings => _bookings;

  Future<void> loadBookings() async {
    _bookings = _db.getBookings();
    notifyListeners();
  }

  Future<void> createBooking({
    required Service service,
    required DateTime dateTime,
  }) async {
    final booking = Booking(
      id: _uuid.v4(),
      serviceId: service.id,
      serviceName: service.name,
      dateTime: dateTime,
      status: 'confirmed',
      totalPrice: service.price,
    );

    await _db.addBooking(booking);
    _bookings.add(booking);

    // Add loyalty points
    final user = _db.getUser();
    if (user != null) {
      final updatedUser = UserProfile(
        name: user.name,
        phone: user.phone,
        email: user.email,
        loyaltyPoints: (user.loyaltyPoints ?? 0) + 10,
      );
      await _db.saveUser(updatedUser);
    }

    notifyListeners();
  }
}
