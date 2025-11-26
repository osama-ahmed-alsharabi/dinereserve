import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/feature/favorites/data/favorites_repo.dart';
import 'package:dinereserve/feature/favorites/presentation/view_model/favorites_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepo favoritesRepo;

  FavoritesCubit(this.favoritesRepo) : super(FavoritesInitial());

  void loadFavorites() async {
    emit(FavoritesLoading());
    final result = await favoritesRepo.getFavorites();
    result.fold(
      (failure) => emit(FavoritesError(failure.errMessage)),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }

  void toggleFavorite(RestaurantModel restaurant) async {
    if (isFavorite(restaurant.restaurantId!)) {
      await favoritesRepo.removeFavorite(restaurant.restaurantId!);
    } else {
      await favoritesRepo.addFavorite(restaurant);
    }
    // Reload to update UI and state
    loadFavorites();
  }

  bool isFavorite(String restaurantId) {
    return favoritesRepo.isFavorite(restaurantId);
  }
}
