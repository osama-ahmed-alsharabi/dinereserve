import 'package:dinereserve/core/widgets/loading_widget.dart';
import 'package:dinereserve/feature/advertisement/presentation/view/widgets/add_advertisement_date_picker.dart';
import 'package:dinereserve/feature/advertisement/presentation/view/widgets/add_advertisement_image_picker.dart';
import 'package:dinereserve/feature/advertisement/presentation/view/widgets/add_advertisement_submit_button.dart';
import 'package:dinereserve/feature/advertisement/presentation/view_model/add_advertisement_cubit.dart';
import 'package:dinereserve/feature/advertisement/presentation/view_model/add_advertisement_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAdvertisementBodyWidget extends StatelessWidget {
  const AddAdvertisementBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddAdvertisementCubit, AddAdvertisementState>(
      listener: (context, state) {
        if (state is AddAdvertisementFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AddAdvertisementSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Advertisement added successfully!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<AddAdvertisementCubit>();
        return LoadingWidget(
          isLoading: state is AddAdvertisementLoading,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create a dazzling ad",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 30),

                // Image Upload Area
                AddAdvertisementImagePicker(
                  selectedImage: cubit.selectedImage,
                  onTap: () => cubit.pickImage(),
                ),
                const SizedBox(height: 40),

                // Date Selection
                Row(
                  children: [
                    Expanded(
                      child: AddAdvertisementDatePicker(
                        label: "Start Date",
                        date: cubit.startDate,
                        onTap: () => cubit.selectStartDate(context),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: AddAdvertisementDatePicker(
                        label: "End Date",
                        date: cubit.endDate,
                        onTap: () => cubit.selectEndDate(context),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Submit Button
                AddAdvertisementSubmitButton(
                  onPressed: () => cubit.submitAdvertisement(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
