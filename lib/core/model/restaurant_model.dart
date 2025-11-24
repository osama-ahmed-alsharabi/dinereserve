class RestaurantModel {
  final String? restaurantId;
  final String restaurantName;
  final String restaurantPhone;
  final String restaurantType;
  final String openingTime;
  final String closingTime;
  final String location;
  final int tablesCount;

  final String? fakeEmail;
  final String? password;
  final String? ownerId; // auth.users id (owner account)

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
    );
  }
}
