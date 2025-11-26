import 'dart:developer';

import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/feature/profile_restaurant/data/profile_restaurant_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EditRestaurantState {}

class EditRestaurantInitial extends EditRestaurantState {}

class EditRestaurantLoading extends EditRestaurantState {}

class EditRestaurantSuccess extends EditRestaurantState {}

class EditRestaurantFailure extends EditRestaurantState {
  final String message;
  EditRestaurantFailure(this.message);
}

class EditRestaurantCubit extends Cubit<EditRestaurantState> {
  final GetRestaurantRepo repository;

  EditRestaurantCubit(this.repository) : super(EditRestaurantInitial());

  Future<void> updateRestaurant({
    required RestaurantModel restaurant,
    String? newLogoPath,
    List<String>? newImagePaths,
  }) async {
    emit(EditRestaurantLoading());
    try {
      RestaurantModel updatedRestaurant = restaurant;

      // Upload Logo
      if (newLogoPath != null) {
        final logoUrl = await repository.uploadImage(newLogoPath);
        updatedRestaurant = updatedRestaurant.copyWith(logo: logoUrl);
      }

      // Upload Table Images
      if (newImagePaths != null && newImagePaths.isNotEmpty) {
        final List<String> currentImages = List.from(restaurant.images);
        for (final path in newImagePaths) {
          final imageUrl = await repository.uploadImage(path);
          currentImages.add(imageUrl);
        }
        updatedRestaurant = updatedRestaurant.copyWith(images: currentImages);
      }

      await repository.updateRestaurant(updatedRestaurant);
      emit(EditRestaurantSuccess());
    } catch (e) {
      log(e.toString());
      emit(EditRestaurantFailure(e.toString()));
    }
  }
}
