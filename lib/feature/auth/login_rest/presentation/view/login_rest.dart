import 'package:dinereserve/feature/auth/login_rest/presentation/view/widgets/login_rest_form_widget.dart';
import 'package:dinereserve/feature/auth/register/presentation/view/widgets/register_background_widget.dart';
import 'package:flutter/material.dart';

class LoginRestView extends StatelessWidget {
  const LoginRestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [RegisterBackgroundWidget(), LoginRestFormWidget()],
        ),
      ),
    );
  }
}
