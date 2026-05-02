import 'package:hive/hive.dart';

part 'offer_model.g.dart';

@HiveType(typeId: 2)
class Offer extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double originalPrice;

  @HiveField(4)
  final double discountedPrice;

  @HiveField(5)
  final String? bannerImageUrl;

  Offer({
    required this.id,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    this.bannerImageUrl,
  });
}
