import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/feature/profile_restaurant/data/profile_restaurant_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<RestaurantModel> restaurants;
  HomeSuccess(this.restaurants);
}

class HomeFailure extends HomeState {
  final String message;
  HomeFailure(this.message);
}

class HomeCubit extends Cubit<HomeState> {
  final GetRestaurantRepo repo;
  HomeCubit(this.repo) : super(HomeInitial());

  Future<void> getAllRestaurants() async {
    emit(HomeLoading());
    try {
      final restaurants = await repo.getAllRestaurants();
      emit(HomeSuccess(restaurants));
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }
}
