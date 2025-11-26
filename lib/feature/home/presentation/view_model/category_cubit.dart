import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/feature/profile_restaurant/data/profile_restaurant_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategorySuccess extends CategoryState {
  final List<RestaurantModel> restaurants;
  CategorySuccess(this.restaurants);
}

class CategoryFailure extends CategoryState {
  final String message;
  CategoryFailure(this.message);
}

class CategoryCubit extends Cubit<CategoryState> {
  final GetRestaurantRepo repo;
  CategoryCubit(this.repo) : super(CategoryInitial());

  Future<void> getRestaurantsByType(String type) async {
    emit(CategoryLoading());
    try {
      final restaurants = await repo.getRestaurantsByType(type);
      emit(CategorySuccess(restaurants));
    } catch (e) {
      emit(CategoryFailure(e.toString()));
    }
  }
}
