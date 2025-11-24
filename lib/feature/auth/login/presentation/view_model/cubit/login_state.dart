abstract class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginSuccess extends LoginState {
  final String userName;

  LoginSuccess({required this.userName});
}

final class LoginLoading extends LoginState {}

final class LoginFaulier extends LoginState {
  final String errorMessage;

  LoginFaulier({required this.errorMessage});
}
