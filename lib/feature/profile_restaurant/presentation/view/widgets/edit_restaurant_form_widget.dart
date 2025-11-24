import 'package:dinereserve/core/helpers/validator_helper.dart';
import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/core/widgets/custom_button_widget.dart';
import 'package:dinereserve/core/widgets/custom_text_from_field_widget.dart';
import 'package:dinereserve/feature/auth/register_rest/presentation/view/widgets/custom_dropdown_field_widget.dart';
import 'package:dinereserve/feature/auth/register_rest/presentation/view/widgets/custom_time_picker_field_widget.dart';
import 'package:dinereserve/feature/profile_restaurant/presentation/view_model/EditRestaurant/edit_restaurant_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditRestaurantFormWidget extends StatefulWidget {
  final RestaurantModel restaurant;
  final VoidCallback onSave;
  final Function(RestaurantModel) onUpdate;

  const EditRestaurantFormWidget({
    super.key,
    required this.restaurant,
    required this.onSave,
    required this.onUpdate,
  });

  @override
  State<EditRestaurantFormWidget> createState() =>
      _EditRestaurantFormWidgetState();
}

class _EditRestaurantFormWidgetState extends State<EditRestaurantFormWidget> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
  late TextEditingController tablesCountController;
  late TextEditingController openTimeController;
  late TextEditingController closeTimeController;
  String? selectedType;

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

  List<TextEditingController> featureControllers = [];
  List<TextEditingController> menuControllers = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.restaurant.restaurantName,
    );
    phoneController = TextEditingController(
      text: widget.restaurant.restaurantPhone,
    );
    locationController = TextEditingController(
      text: widget.restaurant.location,
    );
    tablesCountController = TextEditingController(
      text: widget.restaurant.tablesCount.toString(),
    );
    openTimeController = TextEditingController(
      text: widget.restaurant.openingTime,
    );
    closeTimeController = TextEditingController(
      text: widget.restaurant.closingTime,
    );
    selectedType = widget.restaurant.restaurantType;

    // Initialize Features
    if (widget.restaurant.features.isNotEmpty) {
      for (var feature in widget.restaurant.features) {
        featureControllers.add(TextEditingController(text: feature));
      }
    } else {
      // Add one empty field by default if list is empty? No, let's keep it empty.
    }

    // Initialize Menu
    if (widget.restaurant.menu.isNotEmpty) {
      for (var item in widget.restaurant.menu) {
        menuControllers.add(TextEditingController(text: item));
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    locationController.dispose();
    tablesCountController.dispose();
    openTimeController.dispose();
    closeTimeController.dispose();
    for (var c in featureControllers) {
      c.dispose();
    }
    for (var c in menuControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addFeature() {
    setState(() {
      featureControllers.add(TextEditingController());
    });
  }

  void _removeFeature(int index) {
    setState(() {
      featureControllers[index].dispose();
      featureControllers.removeAt(index);
    });
    _updateModel();
  }

  void _addMenuItem() {
    setState(() {
      menuControllers.add(TextEditingController());
    });
  }

  void _removeMenuItem(int index) {
    setState(() {
      menuControllers[index].dispose();
      menuControllers.removeAt(index);
    });
    _updateModel();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
            onChanged: (v) => _updateModel(),
          ),
          const SizedBox(height: 12),
          CustomTextFromFieldWidget(
            controller: phoneController,
            validator: (v) => ValidatorHelper.validateSaudiPhone(v),
            hint: "Enter restaurant Phone...",
            label: "Restaurant Phone",
            icon: Icons.phone,
            keyboardType: TextInputType.number,
            readOnly: true, // Phone number cannot be changed
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
              _updateModel();
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
            onChanged: (v) => _updateModel(),
          ),
          const SizedBox(height: 12),
          CustomTimePickerFieldWidget(
            controller: closeTimeController,
            label: "Closing Time",
            hint: "Choose closing time",
            icon: Icons.timer_off,
            validator: (v) =>
                ValidatorHelper.validateRequired(v, fieldName: "Closing Time"),
            onChanged: (v) => _updateModel(),
          ),
          const SizedBox(height: 12),
          CustomTextFromFieldWidget(
            controller: locationController,
            validator: (v) =>
                ValidatorHelper.validateRequired(v, fieldName: "Location"),
            hint: "Enter restaurant location...",
            label: "Location",
            icon: Icons.location_on,
            onChanged: (v) => _updateModel(),
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
            onChanged: (v) => _updateModel(),
          ),
          const SizedBox(height: 20),

          // --- Features Section ---
          const Text(
            "Features",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...featureControllers.asMap().entries.map((entry) {
            final index = entry.key;
            final controller = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextFromFieldWidget(
                      controller: controller,
                      hint: "Enter feature...",
                      label: "Feature ${index + 1}",
                      icon: Icons.star,
                      onChanged: (v) => _updateModel(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeFeature(index),
                  ),
                ],
              ),
            );
          }),
          TextButton.icon(
            onPressed: _addFeature,
            icon: const Icon(Icons.add),
            label: const Text("Add Feature"),
          ),
          const SizedBox(height: 20),

          // --- Menu Section ---
          const Text(
            "Food Menu",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...menuControllers.asMap().entries.map((entry) {
            final index = entry.key;
            final controller = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextFromFieldWidget(
                      controller: controller,
                      hint: "Enter food item...",
                      label: "Item ${index + 1}",
                      icon: Icons.restaurant_menu,
                      onChanged: (v) => _updateModel(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeMenuItem(index),
                  ),
                ],
              ),
            );
          }),
          TextButton.icon(
            onPressed: _addMenuItem,
            icon: const Icon(Icons.add),
            label: const Text("Add Menu Item"),
          ),
          const SizedBox(height: 28),

          BlocBuilder<EditRestaurantCubit, EditRestaurantState>(
            builder: (context, state) {
              return CustomButtonWidget(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _updateModel();
                    widget.onSave();
                  }
                },
                child: state is EditRestaurantLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save Changes"),
              );
            },
          ),
        ],
      ),
    );
  }

  void _updateModel() {
    final updatedFeatures = featureControllers
        .map((c) => c.text)
        .where((t) => t.isNotEmpty)
        .toList();
    final updatedMenu = menuControllers
        .map((c) => c.text)
        .where((t) => t.isNotEmpty)
        .toList();

    final updatedRestaurant = widget.restaurant.copyWith(
      restaurantName: nameController.text,
      restaurantType: selectedType,
      openingTime: openTimeController.text,
      closingTime: closeTimeController.text,
      location: locationController.text,
      tablesCount: int.tryParse(tablesCountController.text) ?? 0,
      features: updatedFeatures,
      menu: updatedMenu,
    );
    widget.onUpdate(updatedRestaurant);
  }
}
