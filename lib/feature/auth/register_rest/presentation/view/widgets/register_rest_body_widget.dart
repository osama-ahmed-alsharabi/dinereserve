import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/core/utils/app_text_style.dart';
import 'package:dinereserve/feature/auth/register/presentation/view/widgets/register_background_widget.dart';
import 'package:dinereserve/feature/auth/register_rest/presentation/view/widgets/restaurant_register_form_widget.dart';
import 'package:flutter/material.dart';

class RegisterRestBodyWidget extends StatelessWidget {
  const RegisterRestBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const RegisterBackgroundWidget(),
          SizedBox(height: 37),
          Text(
            "Create an account as a restaurant",
            style: context.textStyle.text20Bold.copyWith(
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(child: RestaurantRegisterFormWidget()),
          ),
        ],
      ),
    );
  }
}
