class AdvertisementModel {
  final String? id;
  final String restaurantId;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? createdAt;

  AdvertisementModel({
    this.id,
    required this.restaurantId,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    this.createdAt,
  });

  factory AdvertisementModel.fromMap(Map<String, dynamic> map) {
    return AdvertisementModel(
      id: map['id'],
      restaurantId: map['restaurant_id'],
      imageUrl: map['image_url'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurant_id': restaurantId,
      'image_url': imageUrl,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }
}
