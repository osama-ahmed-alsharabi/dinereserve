import 'package:dinereserve/core/router/app_router_const.dart';
import 'package:dinereserve/core/widgets/custom_snack_bar.dart';
import 'package:dinereserve/core/widgets/loading_widget.dart';
import 'package:dinereserve/feature/auth/register_rest/presentation/view/widgets/register_rest_body_widget.dart';
import 'package:dinereserve/feature/auth/register_rest/presentation/view_model/cubit/register_restaurant_cubit.dart';
import 'package:dinereserve/feature/auth/register_rest/presentation/view_model/cubit/register_restaurant_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterRestBlocConsumerWidget extends StatelessWidget {
  const RegisterRestBlocConsumerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterRestaurantCubit, RegisterRestaurantState>(
      listener: (context, state) {
        if (state is RegisterRestaurantFaulier) {
          CustomSnackBar.customSnackBar(
            context: context,
            title: state.errorMessage,
            color: Colors.red,
          );
        }

        if (state is RegisterRestaurantSuccess) {
          CustomSnackBar.customSnackBar(
            context: context,
            title: "Registeration Done Successfully",
            color: Colors.green,
          );
          context.pushReplacementNamed(AppRouterConst.loginViewRouteName);
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: state is! RegisterRestaurantLoading,
          child: LoadingWidget(
            isLoading: state is RegisterRestaurantLoading,
            child: RegisterRestBodyWidget()),
        );
      },
    );
  }
}
