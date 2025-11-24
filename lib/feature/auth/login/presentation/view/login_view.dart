import 'package:dinereserve/feature/auth/login/presentation/view/widgets/login_background_widget.dart';
import 'package:dinereserve/feature/auth/login/presentation/view/widgets/login_form_widget.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoginBackgroundWidget(),
          LoginFormWidget(),
        ],
      ),
    );
  }
}
