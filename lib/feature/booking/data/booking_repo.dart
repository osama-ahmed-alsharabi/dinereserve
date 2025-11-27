import 'package:dartz/dartz.dart';
import 'package:dinereserve/core/errors/failure.dart';
import 'package:dinereserve/core/model/booking_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class BookingRepo {
  Future<Either<Failure, void>> createBooking(BookingModel booking);
  Future<Either<Failure, List<BookingModel>>> getUserBookings(String userId);
  Future<Either<Failure, List<BookingModel>>> getRestaurantBookings(
    String restaurantId,
  );
  Future<Either<Failure, void>> updateBookingStatus(
    String bookingId,
    String status,
  );
}

class BookingRepoImpl implements BookingRepo {
  final SupabaseClient supabaseClient;

  BookingRepoImpl({required this.supabaseClient});

  @override
  Future<Either<Failure, void>> createBooking(BookingModel booking) async {
    try {
      await supabaseClient.from('bookings').insert(booking.toMap());
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingModel>>> getUserBookings(
    String userId,
  ) async {
    try {
      final response = await supabaseClient
          .from('bookings')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final bookings = (response as List)
          .map((booking) => BookingModel.fromMap(booking))
          .toList();

      return right(bookings);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingModel>>> getRestaurantBookings(
    String restaurantId,
  ) async {
    try {
      final response = await supabaseClient
          .from('bookings')
          .select()
          .eq('restaurant_id', restaurantId)
          .order('booking_date', ascending: false);

      final bookings = (response as List)
          .map((booking) => BookingModel.fromMap(booking))
          .toList();

      return right(bookings);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBookingStatus(
    String bookingId,
    String status,
  ) async {
    try {
      await supabaseClient
          .from('bookings')
          .update({'status': status})
          .eq('id', bookingId);

      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
