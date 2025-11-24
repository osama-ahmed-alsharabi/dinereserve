import 'package:dinereserve/core/router/app_router_const.dart';
import 'package:dinereserve/core/widgets/custom_snack_bar.dart';
import 'package:dinereserve/core/widgets/loading_widget.dart';
import 'package:dinereserve/feature/auth/login/presentation/view/widgets/login_background_widget.dart';
import 'package:dinereserve/feature/auth/login/presentation/view/widgets/login_form_widget.dart';
import 'package:dinereserve/feature/auth/login/presentation/view_model/cubit/login_cubit.dart';
import 'package:dinereserve/feature/auth/login/presentation/view_model/cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginBodyWidget extends StatelessWidget {
  const LoginBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginFaulier) {
          CustomSnackBar.customSnackBar(
            context: context,
            title: state.errorMessage,
            color: Colors.red,
          );
        }

        if (state is LoginSuccess) {
          CustomSnackBar.customSnackBar(
            context: context,
            title: "Welcome ${state.userName}",
            color: Colors.green,
          );
          context.pushReplacementNamed(AppRouterConst.mainViewRouteName);
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: state is! LoginLoading,

          child: LoadingWidget(
            isLoading: state is LoginLoading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [LoginBackgroundWidget(), LoginFormWidget()],
            ),
          ),
        );
      },
    );
  }
}
