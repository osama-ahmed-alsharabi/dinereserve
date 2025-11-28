import 'package:hive/hive.dart';

part 'notification_model.g.dart';

enum NotificationType {
  bookingConfirmed('booking_confirmed'),
  bookingRejected('booking_rejected');

  final String value;
  const NotificationType(this.value);

  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => NotificationType.bookingConfirmed,
    );
  }
}

@HiveType(typeId: 4)
class NotificationModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String bookingId;

  @HiveField(3)
  final String restaurantId;

  @HiveField(4)
  final String restaurantName;

  @HiveField(5)
  final String type;

  @HiveField(6)
  final String title;

  @HiveField(7)
  final String message;

  @HiveField(8)
  final bool isRead;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime? updatedAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.bookingId,
    required this.restaurantId,
    required this.restaurantName,
    required this.type,
    required this.title,
    required this.message,
    this.isRead = false,
    required this.createdAt,
    this.updatedAt,
  });

  NotificationType get notificationType => NotificationType.fromString(type);

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      bookingId: map['booking_id'] as String,
      restaurantId: map['restaurant_id'] as String,
      restaurantName: map['restaurant_name'] as String,
      type: map['type'] as String,
      title: map['title'] as String,
      message: map['message'] as String,
      isRead: map['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'booking_id': bookingId,
      'restaurant_id': restaurantId,
      'restaurant_name': restaurantName,
      'type': type,
      'title': title,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? bookingId,
    String? restaurantId,
    String? restaurantName,
    String? type,
    String? title,
    String? message,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bookingId: bookingId ?? this.bookingId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
