import 'package:hive/hive.dart';

part 'payment_method_model.g.dart';

@HiveType(typeId: 3)
class PaymentMethodModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String icon;

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  PaymentMethodModel copyWith({String? id, String? name, String? icon}) {
    return PaymentMethodModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }
}
