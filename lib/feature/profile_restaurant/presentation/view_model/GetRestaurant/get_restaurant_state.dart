import 'package:dinereserve/core/model/restaurant_model.dart';

abstract class GetRestaurantState {}

class GetRestaurantInitial extends GetRestaurantState {}

class GetRestaurantLoading extends GetRestaurantState {}

class GetRestaurantSuccess extends GetRestaurantState {
  final RestaurantModel restaurant;
  GetRestaurantSuccess(this.restaurant);
}

class GetRestaurantFailure extends GetRestaurantState {
  final String message;
  GetRestaurantFailure(this.message);
}
