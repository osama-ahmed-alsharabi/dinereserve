import 'package:dinereserve/core/helpers/validator_helper.dart';
import 'package:dinereserve/core/router/app_router_const.dart';
import 'package:dinereserve/core/utils/app_text_style.dart';
import 'package:dinereserve/core/widgets/custom_button_widget.dart';
import 'package:dinereserve/core/widgets/custom_text_from_field_password.dart';
import 'package:dinereserve/core/widgets/custom_text_from_field_widget.dart';
import 'package:dinereserve/feature/auth/login/presentation/view_model/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text("Welcome 👋🏻", style: context.textStyle.text20Mediam),
              Text("Login Now ..", style: context.textStyle.text16Regular),
              SizedBox(height: 15),
              CustomTextFromFieldWidget(
                controller: phoneController,
                validator: (value) => ValidatorHelper.validateSaudiPhone(value),
                padding: 0,
                label: "Phone Number",
                hint: "Enter Your Phone Number",
                icon: Icons.phone,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 15),
              CustomTextFromFieldPassword(
                controller: passwordController,
                validator: (value) => ValidatorHelper.validatePassword(value),
                padding: 0,
                label: "Password",
                hint: "Enter Your Password",
                icon: Icons.lock,
              ),
              Row(
                children: [
                  Text("You Do not Have an Account? "),
                  TextButton(
                    onPressed: () {
                      context.pushNamed(AppRouterConst.registerViewRouteName);
                    },
                    child: Text("Register Now"),
                  ),
                ],
              ),
              SizedBox(height: 35),
              CustomButtonWidget(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    BlocProvider.of<LoginCubit>(context).login(
                      phone: phoneController.text,
                      password: passwordController.text,
                    );
                  } else {
                    autovalidateMode = AutovalidateMode.always;
                    setState(() {});
                  }
                },
                child: Text("Login "),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  context.pushNamed(AppRouterConst.loginRestViewRouteName);
                },
                child: Text(
                  "Login as a Restaurant",
                  style: context.textStyle.text20Mediam,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
