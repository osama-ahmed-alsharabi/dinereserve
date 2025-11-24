import 'package:dinereserve/core/helpers/validator_helper.dart';
import 'package:dinereserve/core/widgets/custom_button_widget.dart';
import 'package:dinereserve/core/widgets/custom_text_from_field_password.dart';
import 'package:dinereserve/core/widgets/custom_text_from_field_widget.dart';
import 'package:dinereserve/feature/auth/register_rest/presentation/view/widgets/custom_dropdown_field_widget.dart';
import 'package:dinereserve/feature/auth/register_rest/presentation/view/widgets/custom_time_picker_field_widget.dart';
import 'package:flutter/material.dart';

class RestaurantRegisterFormWidget extends StatefulWidget {
  const RestaurantRegisterFormWidget({super.key});

  @override
  State<RestaurantRegisterFormWidget> createState() =>
      _RestaurantRegisterFormWidgetState();
}

class _RestaurantRegisterFormWidgetState
    extends State<RestaurantRegisterFormWidget> {
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;

  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController tablesCountController = TextEditingController();

  TextEditingController openTimeController = TextEditingController();
  TextEditingController closeTimeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final List<String> types = [
    "Restaurant",
    "Cafe",
    "Sweets Shop",
    "Fast Food",
    "Bakery",
    "Grill",
    "Breakfast House",
    "Juice Shop",
  ];

  String? selectedType;
  @override
  void dispose() {
    super.dispose();
    confirmPasswordController.dispose();
    passwordController.dispose();
    nameController.dispose();
    locationController.dispose();
    tablesCountController.dispose();
    openTimeController.dispose();
    closeTimeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autoValidate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFromFieldWidget(
            controller: nameController,
            validator: (v) => ValidatorHelper.validateRequired(
              v,
              fieldName: "Restaurant Name",
            ),
            hint: "Enter restaurant name...",
            label: "Restaurant Name",
            icon: Icons.store,
          ),
          const SizedBox(height: 12),
          CustomDropdownFieldWidget(
            label: "Restaurant Type",
            hint: "Select restaurant type",
            icon: Icons.category,
            items: types,
            value: selectedType,
            onChanged: (v) {
              setState(() {
                selectedType = v;
              });
            },
            validator: (v) =>
                v == null ? "Please select restaurant type" : null,
          ),

          const SizedBox(height: 12),
          CustomTimePickerFieldWidget(
            controller: openTimeController,
            label: "Opening Time",
            hint: "Choose opening time",
            icon: Icons.timer,
            validator: (v) =>
                ValidatorHelper.validateRequired(v, fieldName: "Opening Time"),
          ),
          const SizedBox(height: 12),

          CustomTimePickerFieldWidget(
            controller: closeTimeController,
            label: "Closing Time",
            hint: "Choose closing time",
            icon: Icons.timer_off,
            validator: (v) =>
                ValidatorHelper.validateRequired(v, fieldName: "Closing Time"),
          ),

          const SizedBox(height: 12),
          CustomTextFromFieldWidget(
            controller: locationController,
            validator: (v) =>
                ValidatorHelper.validateRequired(v, fieldName: "Location"),
            hint: "Enter restaurant location...",
            label: "Location",
            icon: Icons.location_on,
          ),
          const SizedBox(height: 12),
          CustomTextFromFieldWidget(
            controller: tablesCountController,
            validator: (v) =>
                ValidatorHelper.validateRequired(v, fieldName: "Tables Count"),
            hint: "Enter number of tables...",
            label: "Tables Count",
            icon: Icons.table_bar,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          CustomTextFromFieldPassword(
            controller: tablesCountController,
            validator: (v) => ValidatorHelper.validatePassword(v),
            hint: "Enter number of tables...",
            label: "Tables Count",
            icon: Icons.lock,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          CustomTextFromFieldPassword(
            controller: tablesCountController,
            validator: (v) => ValidatorHelper.validateConfirmPassword(
              v,
              passwordController.text,
            ),
            hint: "Enter number of tables...",
            label: "Tables Count",
            icon: Icons.lock,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomButtonWidget(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // UI ONLY — No Logic Yet
                } else {
                  autoValidate = AutovalidateMode.always;
                  setState(() {});
                }
              },
              child: const Text("Register Restaurant"),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
