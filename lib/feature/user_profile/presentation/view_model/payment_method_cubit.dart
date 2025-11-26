import 'package:dinereserve/core/model/payment_method_model.dart';
import 'package:dinereserve/core/services/payment_method_local_service.dart';
import 'package:dinereserve/feature/user_profile/presentation/view_model/payment_method_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethodCubit extends Cubit<PaymentMethodState> {
  final PaymentMethodLocalService paymentMethodLocalService;

  PaymentMethodCubit(this.paymentMethodLocalService)
    : super(PaymentMethodInitial());

  /// Load the saved payment method
  void loadPaymentMethod() {
    try {
      emit(PaymentMethodLoading());
      final paymentMethod = paymentMethodLocalService.getPaymentMethod();
      emit(PaymentMethodLoaded(paymentMethod));
    } catch (e) {
      emit(PaymentMethodError(e.toString()));
    }
  }

  /// Save selected payment method
  Future<void> savePaymentMethod(PaymentMethodModel paymentMethod) async {
    try {
      emit(PaymentMethodLoading());
      await paymentMethodLocalService.savePaymentMethod(paymentMethod);
      emit(PaymentMethodSaved(paymentMethod));
      // Reload to update state
      loadPaymentMethod();
    } catch (e) {
      emit(PaymentMethodError(e.toString()));
    }
  }

  /// Get current payment method without emitting state
  PaymentMethodModel? getCurrentPaymentMethod() {
    return paymentMethodLocalService.getPaymentMethod();
  }
}
