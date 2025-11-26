import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/services/payment_method_local_service.dart';
import 'package:dinereserve/feature/user_profile/presentation/view/widgets/payment_method_bottom_sheet.dart';
import 'package:dinereserve/feature/user_profile/presentation/view/widgets/user_profile_option.dart';
import 'package:dinereserve/feature/user_profile/presentation/view_model/payment_method_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileSettingsSection extends StatelessWidget {
  const UserProfileSettingsSection({super.key});

  void _showPaymentMethodBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) =>
            PaymentMethodCubit(getIt.get<PaymentMethodLocalService>())
              ..loadPaymentMethod(),
        child: const PaymentMethodBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionHeader('Account Settings'),
        UserProfileOption(
          title: 'Payment Methods',
          icon: Icons.credit_card_outlined,
          onTap: () => _showPaymentMethodBottomSheet(context),
        ),
        UserProfileOption(
          title: 'Privacy Policy',
          icon: Icons.privacy_tip_outlined,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
