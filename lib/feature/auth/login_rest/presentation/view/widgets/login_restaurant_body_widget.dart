import 'package:dinereserve/core/router/app_router_const.dart';
import 'package:dinereserve/core/widgets/custom_snack_bar.dart';
import 'package:dinereserve/core/widgets/loading_widget.dart';
import 'package:dinereserve/feature/auth/login_rest/presentation/view/widgets/login_rest_form_widget.dart';
import 'package:dinereserve/feature/auth/login_rest/presentation/view_model/cubit/login_restaurant_cubit.dart';
import 'package:dinereserve/feature/auth/login_rest/presentation/view_model/cubit/login_restaurant_state.dart';
import 'package:dinereserve/feature/auth/register/presentation/view/widgets/register_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginRestaurantBodyWidget extends StatelessWidget {
  const LoginRestaurantBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginRestaurantCubit, LoginRestaurantState>(
      listener: (context, state) {
        if (state is LoginRestaurantFaulier) {
          CustomSnackBar.customSnackBar(
            context: context,
            title: state.errorMessage,
            color: Colors.red,
          );
        }

        if (state is LoginRestaurantSuccess) {
          CustomSnackBar.customSnackBar(
            context: context,
            title: "Welcome ${state.restaurantModel.restaurantName}",
            color: Colors.green,
          );
          context.goNamed(AppRouterConst.mainRestViewRouteName);
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: state is! LoginRestaurantLoading,
          child: LoadingWidget(
            isLoading: state is LoginRestaurantLoading,
            child: SafeArea(
              child: Column(
                children: [RegisterBackgroundWidget(), LoginRestFormWidget()],
              ),
            ),
          ),
        );
      },
    );
  }
}
