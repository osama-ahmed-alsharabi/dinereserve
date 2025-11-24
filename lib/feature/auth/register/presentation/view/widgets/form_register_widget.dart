import 'package:dinereserve/core/helpers/validator_helper.dart';
import 'package:dinereserve/core/model/user_model.dart';
import 'package:dinereserve/core/widgets/custom_button_widget.dart';
import 'package:dinereserve/core/widgets/custom_text_from_field_password.dart';
import 'package:dinereserve/core/widgets/custom_text_from_field_widget.dart';
import 'package:dinereserve/feature/auth/register/presentation/view_model/cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormRegisterWidget extends StatefulWidget {
  const FormRegisterWidget({super.key});

  @override
  State<FormRegisterWidget> createState() => _FormRegisterWidgetState();
}

class _FormRegisterWidgetState extends State<FormRegisterWidget> {
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
    ageController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        children: [
          CustomTextFromFieldWidget(
            validator: (value) => ValidatorHelper.validateFullName(value),

            controller: nameController,
            hint: "Enter your full name...",
            label: "Full Name",
            icon: Icons.person,
          ),
          const SizedBox(height: 12),

          // Phone Number
          CustomTextFromFieldWidget(
            validator: (v) => ValidatorHelper.validateSaudiPhone(v),
            controller: phoneController,
            hint: "Enter your phone number...",
            label: "Phone Number",
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),

          // Age
          CustomTextFromFieldWidget(
            validator: (v) => ValidatorHelper.validateAge(v),
            controller: ageController,
            hint: "Enter your age...",
            label: "Age",
            icon: Icons.calendar_today,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),

          // Password
          CustomTextFromFieldPassword(
            validator: (v) => ValidatorHelper.validatePassword(v),

            controller: passwordController,
            hint: "Enter your password...",
            label: "Password",
            icon: Icons.lock,
            // isPassword: true,
          ),
          const SizedBox(height: 12),

          // Confirm Password
          CustomTextFromFieldPassword(
            validator: (v) => ValidatorHelper.validateConfirmPassword(
              v,
              passwordController.text,
            ),
            controller: confirmPasswordController,
            hint: "Confirm your password...",
            label: "Confirm Password",
            icon: Icons.lock_outline,
            // isPassword: true,
          ),

          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomButtonWidget(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  BlocProvider.of<RegisterCubit>(context).register(
                    UserModel(
                      fullName: nameController.text,
                      phoneNumber: phoneController.text,
                      fakeEmail: "user_${phoneController.text}@auth.local",
                      age: ageController.text,
                      password: passwordController.text,
                    ),
                  );
                } else {
                  autovalidateMode = AutovalidateMode.always;
                  setState(() {});
                }
              },
              child: Text("Register Now"),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
