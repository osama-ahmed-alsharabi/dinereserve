class BookingModel {
  final String? id;
  final String userId;
  final String userName;
  final String userPhone;
  final String restaurantId;
  final String restaurantName;
  final DateTime bookingDate;
  final String bookingTime; // Format: "HH:mm"
  final int tableCount;
  final String paymentMethodId;
  final String paymentMethodName;
  final String status; // pending, confirmed, rejected, cancelled
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BookingModel({
    this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.restaurantId,
    required this.restaurantName,
    required this.bookingDate,
    required this.bookingTime,
    required this.tableCount,
    required this.paymentMethodId,
    required this.paymentMethodName,
    this.status = 'pending',
    this.createdAt,
    this.updatedAt,
  });

  // From Supabase JSON
  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'],
      userId: map['user_id'],
      userName: map['user_name'],
      userPhone: map['user_phone'],
      restaurantId: map['restaurant_id'],
      restaurantName: map['restaurant_name'],
      bookingDate: DateTime.parse(map['booking_date']),
      bookingTime: map['booking_time'],
      tableCount: map['table_count'],
      paymentMethodId: map['payment_method_id'],
      paymentMethodName: map['payment_method_name'],
      status: map['status'] ?? 'pending',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }

  // To Supabase JSON
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': id,
      'user_name': userName,
      'user_phone': userPhone,
      'restaurant_id': restaurantId,
      'restaurant_name': restaurantName,
      'booking_date': bookingDate.toIso8601String().split('T')[0],
      'booking_time': bookingTime,
      'table_count': tableCount,
      'payment_method_id': paymentMethodId,
      'payment_method_name': paymentMethodName,
      'status': status,
    };
  }

  BookingModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userPhone,
    String? restaurantId,
    String? restaurantName,
    DateTime? bookingDate,
    String? bookingTime,
    int? tableCount,
    String? paymentMethodId,
    String? paymentMethodName,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      bookingDate: bookingDate ?? this.bookingDate,
      bookingTime: bookingTime ?? this.bookingTime,
      tableCount: tableCount ?? this.tableCount,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      paymentMethodName: paymentMethodName ?? this.paymentMethodName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
