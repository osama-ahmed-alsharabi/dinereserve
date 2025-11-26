import 'package:hive/hive.dart';
import 'package:dinereserve/core/model/payment_method_model.dart';

class PaymentMethodLocalService {
  static const String paymentMethodBoxName = "payment_method_box";
  static const String paymentMethodKey = "selected_payment_method";

  final Box<PaymentMethodModel> box;

  PaymentMethodLocalService(this.box);

  /// Save selected payment method
  Future<void> savePaymentMethod(PaymentMethodModel paymentMethod) async {
    await box.put(paymentMethodKey, paymentMethod);
  }

  /// Get selected payment method
  PaymentMethodModel? getPaymentMethod() {
    return box.get(paymentMethodKey);
  }

  /// Check if payment method is set
  bool hasPaymentMethod() {
    return box.get(paymentMethodKey) != null;
  }

  /// Clear payment method
  Future<void> clearPaymentMethod() async {
    await box.delete(paymentMethodKey);
  }
}
