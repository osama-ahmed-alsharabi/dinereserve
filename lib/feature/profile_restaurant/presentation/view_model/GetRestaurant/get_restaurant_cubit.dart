import 'package:dinereserve/feature/profile_restaurant/data/profile_restaurant_repo.dart';
import 'package:dinereserve/feature/profile_restaurant/presentation/view_model/GetRestaurant/get_restaurant_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetRestaurantCubit extends Cubit<GetRestaurantState> {
  final GetRestaurantRepo repository;

  GetRestaurantCubit(this.repository) : super(GetRestaurantInitial());

  Future<void> fetchRestaurant() async {
    emit(GetRestaurantLoading());
    try {
      final restaurant = await repository.getRestaurantByOwner();
      emit(GetRestaurantSuccess(restaurant));
    } catch (e) {
      emit(GetRestaurantFailure(e.toString()));
    }
  }
}
