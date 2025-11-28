import 'package:dartz/dartz.dart';
import 'package:dinereserve/core/errors/failure.dart';
import 'package:dinereserve/core/model/booking_model.dart';
import 'package:dinereserve/core/model/dashboard_analytics_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DashboardRepo {
  Future<Either<Failure, DashboardAnalyticsModel>> getRestaurantAnalytics(
    String restaurantId,
    DateTime startDate,
    DateTime endDate,
  );
}

class DashboardRepoImpl implements DashboardRepo {
  final SupabaseClient supabaseClient;

  DashboardRepoImpl({required this.supabaseClient});

  @override
  Future<Either<Failure, DashboardAnalyticsModel>> getRestaurantAnalytics(
    String restaurantId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      // Fetch bookings for the specified period
      final response = await supabaseClient
          .from('bookings')
          .select()
          .eq('restaurant_id', restaurantId)
          .gte('booking_date', startDate.toIso8601String().split('T')[0])
          .lte('booking_date', endDate.toIso8601String().split('T')[0]);

      final bookings = (response as List)
          .map((booking) => BookingModel.fromMap(booking))
          .toList();

      // Calculate analytics
      final analytics = _calculateAnalytics(bookings);

      return right(analytics);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  DashboardAnalyticsModel _calculateAnalytics(List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return DashboardAnalyticsModel.empty();
    }

    int totalBookings = bookings.length;
    int confirmedBookings = bookings
        .where((b) => b.status == 'confirmed')
        .length;
    int pendingBookings = bookings.where((b) => b.status == 'pending').length;
    int rejectedBookings = bookings.where((b) => b.status == 'rejected').length;
    int cancelledBookings = bookings
        .where((b) => b.status == 'cancelled')
        .length;

    int totalTables = bookings.fold(0, (sum, b) => sum + b.tableCount);

    double acceptanceRate = totalBookings > 0
        ? (confirmedBookings / totalBookings * 100)
        : 0.0;

    // Group by date
    Map<String, int> bookingsByDate = {};
    for (var booking in bookings) {
      String dateKey = booking.bookingDate.toIso8601String().split('T')[0];
      bookingsByDate[dateKey] = (bookingsByDate[dateKey] ?? 0) + 1;
    }

    // Group by hour
    Map<String, int> bookingsByTime = {};
    for (var booking in bookings) {
      String hour = booking.bookingTime.split(':')[0];
      bookingsByTime[hour] = (bookingsByTime[hour] ?? 0) + 1;
    }

    return DashboardAnalyticsModel(
      totalBookings: totalBookings,
      confirmedBookings: confirmedBookings,
      pendingBookings: pendingBookings,
      rejectedBookings: rejectedBookings,
      cancelledBookings: cancelledBookings,
      totalTables: totalTables,
      acceptanceRate: acceptanceRate,
      bookingsByDate: bookingsByDate,
      bookingsByTime: bookingsByTime,
    );
  }
}
