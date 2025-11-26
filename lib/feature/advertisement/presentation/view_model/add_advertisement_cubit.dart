import 'dart:io';
import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/model/advertisement_model.dart';
import 'package:dinereserve/core/services/restaurant_local_service.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/feature/advertisement/data/advertisement_repo.dart';
import 'package:dinereserve/feature/advertisement/presentation/view_model/add_advertisement_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddAdvertisementCubit extends Cubit<AddAdvertisementState> {
  AddAdvertisementCubit() : super(AddAdvertisementInitial());

  File? selectedImage;
  DateTime? startDate;
  DateTime? endDate;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      emit(AddAdvertisementImageSelected(selectedImage!));
    }
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await _showCustomDatePicker(context);
    if (picked != null) {
      startDate = picked;
      emit(
        AddAdvertisementDateSelected(startDate: startDate, endDate: endDate),
      );
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await _showCustomDatePicker(context);
    if (picked != null) {
      endDate = picked;
      emit(
        AddAdvertisementDateSelected(startDate: startDate, endDate: endDate),
      );
    }
  }

  Future<DateTime?> _showCustomDatePicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
  }

  Future<void> submitAdvertisement() async {
    if (selectedImage == null || startDate == null || endDate == null) {
      emit(AddAdvertisementFailure("Please fill all fields"));
      return;
    }

    emit(AddAdvertisementLoading());

    final restaurant = getIt.get<RestaurantLocalService>().getRestaurant();
    if (restaurant == null) {
      emit(AddAdvertisementFailure("Restaurant not logged in"));
      return;
    }

    final ad = AdvertisementModel(
      restaurantId: restaurant.restaurantId ?? "",
      imageUrl: "",
      startDate: startDate!,
      endDate: endDate!,
    );

    final repo = AdvertisementRepoImpl(
      supabaseClient: getIt.get<SupabaseClient>(),
    );
    final result = await repo.uploadAdvertisement(ad, selectedImage!);
    result.fold(
      (failure) => emit(AddAdvertisementFailure(failure.errMessage)),
      (_) => emit(AddAdvertisementSuccess()),
    );
  }
}
