abstract class RegisterRestaurantState {}

final class RegisterRestaurantInitial extends RegisterRestaurantState {}

final class RegisterRestaurantSuccess extends RegisterRestaurantState {}

final class RegisterRestaurantLoading extends RegisterRestaurantState {}

final class RegisterRestaurantFaulier extends RegisterRestaurantState {
  final String errorMessage;

  RegisterRestaurantFaulier({required this.errorMessage});
}
