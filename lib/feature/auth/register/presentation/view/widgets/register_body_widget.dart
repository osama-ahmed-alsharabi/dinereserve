import 'package:dinereserve/core/utils/app_text_style.dart';
import 'package:dinereserve/core/widgets/custom_snack_bar.dart';
import 'package:dinereserve/core/widgets/loading_widget.dart';
import 'package:dinereserve/feature/auth/register/presentation/view/widgets/form_register_widget.dart';
import 'package:dinereserve/feature/auth/register/presentation/view/widgets/register_background_widget.dart';
import 'package:dinereserve/feature/auth/register/presentation/view_model/cubit/register_cubit.dart';
import 'package:dinereserve/feature/auth/register/presentation/view_model/cubit/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegiserBodyWidget extends StatelessWidget {
  const RegiserBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailuer) {
          CustomSnackBar.customSnackBar(
            context: context,
            title: state.errorMessage,
            color: Colors.red,
          );
        }
        if (state is RegisterSuccess) {
          CustomSnackBar.customSnackBar(
            context: context,
            title: "Registeration Done Successfully",
            color: Colors.green,
          );
          context.pop();
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: state is! RegisterLoading,
          child: LoadingWidget(
            isLoading: state is RegisterLoading,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const RegisterBackgroundWidget(),
                    const SizedBox(height: 40),
                    Text(
                      "Create Account",
                      style: context.textStyle.text20Mediam,
                    ),
                    Text(
                      "Create your new account",
                      style: context.textStyle.text12Regular,
                    ),
                    const SizedBox(height: 24),
                    FormRegisterWidget(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
