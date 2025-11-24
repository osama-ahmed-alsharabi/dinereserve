import 'package:hive/hive.dart';

part 'restaurant_model.g.dart';

@HiveType(typeId: 2)
class RestaurantModel {
  @HiveField(0)
  final String? restaurantId;

  @HiveField(1)
  final String restaurantName;

  @HiveField(2)
  final String restaurantPhone;

  @HiveField(3)
  final String restaurantType;

  @HiveField(4)
  final String openingTime;

  @HiveField(5)
  final String closingTime;

  @HiveField(6)
  final String location;

  @HiveField(7)
  final int tablesCount;

  @HiveField(8)
  final String? fakeEmail;

  @HiveField(9)
  final String? password;

  @HiveField(10)
  final String? ownerId;

  // NEW FIELDS ↓↓↓
  @HiveField(11)
  final List<String> images; // max 5 URLs

  @HiveField(12)
  final List<String> features; // restaurant features

  @HiveField(13)
  final List<String> menu; // restaurant menu items

  @HiveField(14)
  final String? logo; // restaurant logo
  // ↑↑↑ NEW

  RestaurantModel({
    this.restaurantId,
    required this.restaurantName,
    required this.restaurantPhone,
    required this.restaurantType,
    required this.openingTime,
    required this.closingTime,
    required this.location,
    required this.tablesCount,
    this.fakeEmail,
    this.password,
    this.ownerId,
    this.images = const [],
    this.features = const [],
    this.menu = const [],
    this.logo,
  });

  /// Convert FROM Supabase
  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      restaurantId: map["restaurant_id"],
      restaurantName: map["restaurant_name"] ?? "",
      restaurantPhone: map["restaurant_phone"] ?? "",
      restaurantType: map["restaurant_type"] ?? "",
      openingTime: map["opening_time"] ?? "",
      closingTime: map["closing_time"] ?? "",
      location: map["location"] ?? "",
      tablesCount: map["tables_count"] ?? 0,
      fakeEmail: map["fake_email"],
      password: map["password"],
      ownerId: map["owner_id"],
      images: List<String>.from(map["images"] ?? []),
      features: List<String>.from(map["features"] ?? []),
      menu: List<String>.from(map["menu"] ?? []),
      logo: map["logo"],
    );
  }

  /// Convert TO Supabase insert/update map
  Map<String, dynamic> toMap() {
    return {
      "restaurant_name": restaurantName,
      "restaurant_phone": restaurantPhone,
      "restaurant_type": restaurantType,
      "opening_time": openingTime,
      "closing_time": closingTime,
      "location": location,
      "tables_count": tablesCount,
      "fake_email": fakeEmail,
      "password": password,
      "owner_id": ownerId,
      "images": images,
      "features": features,
      "menu": menu,
      "logo": logo,
    };
  }

  /// Copy model values
  RestaurantModel copyWith({
    String? restaurantId,
    String? restaurantName,
    String? restaurantPhone,
    String? restaurantType,
    String? openingTime,
    String? closingTime,
    String? location,
    int? tablesCount,
    String? fakeEmail,
    String? password,
    String? ownerId,
    List<String>? images,
    List<String>? features,
    List<String>? menu,
    String? logo,
  }) {
    return RestaurantModel(
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantPhone: restaurantPhone ?? this.restaurantPhone,
      restaurantType: restaurantType ?? this.restaurantType,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      location: location ?? this.location,
      tablesCount: tablesCount ?? this.tablesCount,
      fakeEmail: fakeEmail ?? this.fakeEmail,
      password: password ?? this.password,
      ownerId: ownerId ?? this.ownerId,
      images: images ?? this.images,
      features: features ?? this.features,
      menu: menu ?? this.menu,
      logo: logo ?? this.logo,
    );
  }
}
