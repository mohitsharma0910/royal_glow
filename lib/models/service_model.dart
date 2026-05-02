import 'package:hive/hive.dart';

part 'service_model.g.dart';

@HiveType(typeId: 0)
class Service extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final String iconPath;

  @HiveField(5)
  final String category;

  @HiveField(6)
  final int? durationMinutes;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.iconPath,
    required this.category,
    this.durationMinutes = 30,
  });
}
