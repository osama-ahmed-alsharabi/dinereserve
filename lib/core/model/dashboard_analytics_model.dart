class DashboardAnalyticsModel {
  final int totalBookings;
  final int confirmedBookings;
  final int pendingBookings;
  final int rejectedBookings;
  final int cancelledBookings;
  final int totalTables;
  final double acceptanceRate;
  final Map<String, int> bookingsByDate; // Date -> Count
  final Map<String, int> bookingsByTime; // Hour -> Count

  DashboardAnalyticsModel({
    required this.totalBookings,
    required this.confirmedBookings,
    required this.pendingBookings,
    required this.rejectedBookings,
    required this.cancelledBookings,
    required this.totalTables,
    required this.acceptanceRate,
    required this.bookingsByDate,
    required this.bookingsByTime,
  });

  factory DashboardAnalyticsModel.empty() {
    return DashboardAnalyticsModel(
      totalBookings: 0,
      confirmedBookings: 0,
      pendingBookings: 0,
      rejectedBookings: 0,
      cancelledBookings: 0,
      totalTables: 0,
      acceptanceRate: 0.0,
      bookingsByDate: {},
      bookingsByTime: {},
    );
  }

  DashboardAnalyticsModel copyWith({
    int? totalBookings,
    int? confirmedBookings,
    int? pendingBookings,
    int? rejectedBookings,
    int? cancelledBookings,
    int? totalTables,
    double? acceptanceRate,
    Map<String, int>? bookingsByDate,
    Map<String, int>? bookingsByTime,
  }) {
    return DashboardAnalyticsModel(
      totalBookings: totalBookings ?? this.totalBookings,
      confirmedBookings: confirmedBookings ?? this.confirmedBookings,
      pendingBookings: pendingBookings ?? this.pendingBookings,
      rejectedBookings: rejectedBookings ?? this.rejectedBookings,
      cancelledBookings: cancelledBookings ?? this.cancelledBookings,
      totalTables: totalTables ?? this.totalTables,
      acceptanceRate: acceptanceRate ?? this.acceptanceRate,
      bookingsByDate: bookingsByDate ?? this.bookingsByDate,
      bookingsByTime: bookingsByTime ?? this.bookingsByTime,
    );
  }
}
