import 'package:hive_flutter/hive_flutter.dart';
import '../models/service_model.dart';
import '../models/booking_model.dart';
import '../models/offer_model.dart';
import '../models/user_model.dart';

class DatabaseService {
  static const String servicesBoxName = 'services';
  static const String bookingsBoxName = 'bookings';
  static const String offersBoxName = 'offers';
  static const String userBoxName = 'user';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(ServiceAdapter());
    Hive.registerAdapter(BookingAdapter());
    Hive.registerAdapter(OfferAdapter());
    Hive.registerAdapter(UserProfileAdapter());

    // Open boxes
    await Hive.openBox<Service>(servicesBoxName);
    await Hive.openBox<Booking>(bookingsBoxName);
    await Hive.openBox<Offer>(offersBoxName);
    await Hive.openBox<UserProfile>(userBoxName);
  }

  // Generic methods
  Box<T> getBox<T>(String name) => Hive.box<T>(name);

  // User methods
  UserProfile? getUser() {
    final box = getBox<UserProfile>(userBoxName);
    return box.get('current_user');
  }

  Future<void> saveUser(UserProfile user) async {
    final box = getBox<UserProfile>(userBoxName);
    await box.put('current_user', user);
  }

  // Booking methods
  List<Booking> getBookings() {
    final box = getBox<Booking>(bookingsBoxName);
    return box.values.toList();
  }

  Future<void> addBooking(Booking booking) async {
    final box = getBox<Booking>(bookingsBoxName);
    await box.add(booking);
  }

  Future<void> cancelBooking(String bookingId) async {
    final box = getBox<Booking>(bookingsBoxName);
    final entries = box.toMap();
    for (final entry in entries.entries) {
      if (entry.value.id == bookingId) {
        final cancelled = Booking(
          id: entry.value.id,
          serviceId: entry.value.serviceId,
          serviceName: entry.value.serviceName,
          dateTime: entry.value.dateTime,
          status: 'cancelled',
          totalPrice: entry.value.totalPrice,
        );
        await box.put(entry.key, cancelled);
        return;
      }
    }
  }

  // Service methods
  List<Service> getServices() {
    final box = getBox<Service>(servicesBoxName);
    return box.values.toList();
  }

  Future<void> saveServices(List<Service> services) async {
    final box = getBox<Service>(servicesBoxName);
    await box.clear();
    await box.addAll(services);
  }
}
