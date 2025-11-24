import 'package:dinereserve/core/utils/app_text_style.dart';
import 'package:dinereserve/feature/auth/register/presentation/view/widgets/form_register_widget.dart';
import 'package:dinereserve/feature/auth/register/presentation/view/widgets/register_background_widget.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const RegisterBackgroundWidget(),
              const SizedBox(height: 40),
              Text("Create Account", style: context.textStyle.text20Mediam),
              Text(
                "Create your new account",
                style: context.textStyle.text12Regular,
              ),
              const SizedBox(height: 24),
              // Full Name
              FormRegisterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
