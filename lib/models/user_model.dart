import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 3)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String phone;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final int? loyaltyPoints;

  UserProfile({
    required this.name,
    required this.phone,
    this.email,
    this.loyaltyPoints = 0,
  });
}
