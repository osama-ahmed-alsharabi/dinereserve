import 'package:dinereserve/core/model/payment_method_model.dart';

abstract class PaymentMethodState {}

class PaymentMethodInitial extends PaymentMethodState {}

class PaymentMethodLoading extends PaymentMethodState {}

class PaymentMethodLoaded extends PaymentMethodState {
  final PaymentMethodModel? paymentMethod;

  PaymentMethodLoaded(this.paymentMethod);
}

class PaymentMethodSaved extends PaymentMethodState {
  final PaymentMethodModel paymentMethod;

  PaymentMethodSaved(this.paymentMethod);
}

class PaymentMethodError extends PaymentMethodState {
  final String message;

  PaymentMethodError(this.message);
}
