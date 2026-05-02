import 'package:hive/hive.dart';

part 'booking_model.g.dart';

@HiveType(typeId: 1)
class Booking extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String serviceId;

  @HiveField(2)
  final String serviceName;

  @HiveField(3)
  final DateTime dateTime;

  @HiveField(4)
  final String status; // 'pending', 'confirmed', 'cancelled'

  @HiveField(5)
  final double totalPrice;

  Booking({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.dateTime,
    required this.status,
    required this.totalPrice,
  });
}
