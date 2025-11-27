import 'package:dinereserve/core/model/booking_model.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingCreated extends BookingState {
  final BookingModel booking;

  BookingCreated(this.booking);
}

class BookingError extends BookingState {
  final String message;

  BookingError(this.message);
}

class UserBookingsLoaded extends BookingState {
  final List<BookingModel> bookings;

  UserBookingsLoaded(this.bookings);
}

class RestaurantBookingsLoaded extends BookingState {
  final List<BookingModel> bookings;

  RestaurantBookingsLoaded(this.bookings);
}

class BookingStatusUpdated extends BookingState {
  final String bookingId;
  final String newStatus;

  BookingStatusUpdated(this.bookingId, this.newStatus);
}
