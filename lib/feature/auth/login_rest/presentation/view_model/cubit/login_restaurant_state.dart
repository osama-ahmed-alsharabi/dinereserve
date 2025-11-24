import 'package:dinereserve/core/model/restaurant_model.dart';

abstract class LoginRestaurantState {}

final class LoginRestaurantInitial extends LoginRestaurantState {}

final class LoginRestaurantSuccess extends LoginRestaurantState {
  final RestaurantModel restaurantModel;

  LoginRestaurantSuccess({required this.restaurantModel});
}

final class LoginRestaurantLoading extends LoginRestaurantState {}

final class LoginRestaurantFaulier extends LoginRestaurantState {
  final String errorMessage;

  LoginRestaurantFaulier({required this.errorMessage});
}
