abstract class LoginRestaurantState {}

final class LoginRestaurantInitial extends LoginRestaurantState {}

final class LoginRestaurantSuccess extends LoginRestaurantState {}

final class LoginRestaurantLoading extends LoginRestaurantState {}

final class LoginRestaurantFaulier extends LoginRestaurantState {
  final String errorMessage;

  LoginRestaurantFaulier({required this.errorMessage});
}
