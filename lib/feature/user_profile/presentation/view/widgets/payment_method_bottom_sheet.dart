import 'package:dinereserve/core/model/payment_method_model.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/feature/user_profile/presentation/view/widgets/payment_method_header.dart';
import 'package:dinereserve/feature/user_profile/presentation/view/widgets/payment_method_option_card.dart';
import 'package:dinereserve/feature/user_profile/presentation/view_model/payment_method_cubit.dart';
import 'package:dinereserve/feature/user_profile/presentation/view_model/payment_method_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethodBottomSheet extends StatefulWidget {
  const PaymentMethodBottomSheet({super.key});

  @override
  State<PaymentMethodBottomSheet> createState() =>
      _PaymentMethodBottomSheetState();
}

class _PaymentMethodBottomSheetState extends State<PaymentMethodBottomSheet> {
  String? selectedPaymentMethodId;

  final List<Map<String, dynamic>> paymentMethods = [
    {'id': 'apple_pay', 'name': 'Apple Pay', 'icon': Icons.apple},
    {
      'id': 'google_pay',
      'name': 'Google Pay',
      'icon': Icons.g_mobiledata_rounded,
    },
    {'id': 'visa', 'name': 'Visa Card', 'icon': Icons.credit_card},
    {
      'id': 'mastercard',
      'name': 'Mastercard',
      'icon': Icons.credit_card_rounded,
    },
    {'id': 'cash', 'name': 'Cash', 'icon': Icons.money},
  ];

  @override
  void initState() {
    super.initState();
    // Load current payment method
    final currentMethod = context
        .read<PaymentMethodCubit>()
        .getCurrentPaymentMethod();
    if (currentMethod != null) {
      selectedPaymentMethodId = currentMethod.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PaymentMethodHeader(),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ...paymentMethods.map((method) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PaymentMethodOptionCard(
                        id: method['id'],
                        name: method['name'],
                        icon: method['icon'],
                        isSelected: selectedPaymentMethodId == method['id'],
                        onTap: () {
                          setState(() {
                            selectedPaymentMethodId = method['id'];
                          });
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          // Save Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<PaymentMethodCubit, PaymentMethodState>(
              listener: (context, state) {
                if (state is PaymentMethodSaved) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Payment method saved: ${state.paymentMethod.name}',
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                } else if (state is PaymentMethodError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.message}'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is PaymentMethodLoading;
                return SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading || selectedPaymentMethodId == null
                        ? null
                        : () {
                            final selected = paymentMethods.firstWhere(
                              (m) => m['id'] == selectedPaymentMethodId,
                            );
                            final paymentMethod = PaymentMethodModel(
                              id: selected['id'],
                              name: selected['name'],
                              icon: selected['icon'].toString(),
                            );
                            context
                                .read<PaymentMethodCubit>()
                                .savePaymentMethod(paymentMethod);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shadowColor: AppColors.primaryColor.withAlpha(102),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "Save Payment Method",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
