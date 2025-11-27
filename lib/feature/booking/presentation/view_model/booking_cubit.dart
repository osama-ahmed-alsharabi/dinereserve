import 'package:dinereserve/core/model/booking_model.dart';
import 'package:dinereserve/feature/booking/data/booking_repo.dart';
import 'package:dinereserve/feature/booking/presentation/view_model/booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepo bookingRepo;

  BookingCubit(this.bookingRepo) : super(BookingInitial());

  /// Create a new booking
  Future<void> createBooking(BookingModel booking) async {
    emit(BookingLoading());
    final result = await bookingRepo.createBooking(booking);
    result.fold(
      (failure) => emit(BookingError(failure.errMessage)),
      (_) => emit(BookingCreated(booking)),
    );
  }

  /// Load user bookings
  Future<void> loadUserBookings(String userId) async {
    emit(BookingLoading());
    final result = await bookingRepo.getUserBookings(userId);
    result.fold(
      (failure) => emit(BookingError(failure.errMessage)),
      (bookings) => emit(UserBookingsLoaded(bookings)),
    );
  }

  /// Load restaurant bookings
  Future<void> loadRestaurantBookings(String restaurantId) async {
    emit(BookingLoading());
    final result = await bookingRepo.getRestaurantBookings(restaurantId);
    result.fold(
      (failure) => emit(BookingError(failure.errMessage)),
      (bookings) => emit(RestaurantBookingsLoaded(bookings)),
    );
  }

  /// Update booking status (confirm/reject)
  Future<void> updateBookingStatus(String bookingId, String status) async {
    emit(BookingLoading());
    final result = await bookingRepo.updateBookingStatus(bookingId, status);
    result.fold(
      (failure) => emit(BookingError(failure.errMessage)),
      (_) => emit(BookingStatusUpdated(bookingId, status)),
    );
  }

  /// Validate booking time against restaurant hours
  bool validateBookingTime({
    required DateTime bookingDate,
    required String bookingTime,
    required String restaurantOpenTime,
    required String restaurantCloseTime,
  }) {
    try {
      // Check if booking date is not in the past
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final selectedDate = DateTime(
        bookingDate.year,
        bookingDate.month,
        bookingDate.day,
      );

      if (selectedDate.isBefore(today)) {
        return false;
      }

      // Parse times
      final bookingTimeParts = bookingTime.split(':');
      final bookingHour = int.parse(bookingTimeParts[0]);
      final bookingMinute = int.parse(bookingTimeParts[1]);

      final openTime = _parseTime(restaurantOpenTime);
      final closeTime = _parseTime(restaurantCloseTime);

      final bookingTimeOfDay = TimeOfDay(
        hour: bookingHour,
        minute: bookingMinute,
      );

      final bookingMinutes =
          bookingTimeOfDay.hour * 60 + bookingTimeOfDay.minute;
      final openMinutes = openTime.hour * 60 + openTime.minute;
      final closeMinutes = closeTime.hour * 60 + closeTime.minute;

      // Check if booking time is within restaurant hours
      if (closeMinutes < openMinutes) {
        // Overnight hours
        return bookingMinutes >= openMinutes || bookingMinutes <= closeMinutes;
      } else {
        // Standard hours
        return bookingMinutes >= openMinutes && bookingMinutes <= closeMinutes;
      }
    } catch (e) {
      return false;
    }
  }

  TimeOfDay _parseTime(String time) {
    try {
      final parts = time.trim().split(' ');
      if (parts.length == 2) {
        final timeParts = parts[0].split(':');
        if (timeParts.length == 2) {
          int hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          final isPM = parts[1].toUpperCase() == 'PM';

          if (isPM && hour != 12) {
            hour += 12;
          } else if (!isPM && hour == 12) {
            hour = 0;
          }

          return TimeOfDay(hour: hour, minute: minute);
        }
      }

      final parts24 = time.split(':');
      if (parts24.length == 2) {
        return TimeOfDay(
          hour: int.parse(parts24[0]),
          minute: int.parse(parts24[1]),
        );
      }
    } catch (e) {
      // Return midnight on error
    }
    return const TimeOfDay(hour: 0, minute: 0);
  }
}
