import 'package:dinereserve/feature/auth/register_rest/presentation/view/widgets/register_rest_body_widget.dart';
import 'package:flutter/material.dart';

class RegisterRestView extends StatelessWidget {
  const RegisterRestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegisterRestBodyWidget(),
    );
  }
}
