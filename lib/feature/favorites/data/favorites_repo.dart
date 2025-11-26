import 'package:dartz/dartz.dart';
import 'package:dinereserve/core/errors/failure.dart';
import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:hive/hive.dart';

abstract class FavoritesRepo {
  Future<Either<Failure, void>> addFavorite(RestaurantModel restaurant);
  Future<Either<Failure, void>> removeFavorite(String restaurantId);
  Future<Either<Failure, List<RestaurantModel>>> getFavorites();
  bool isFavorite(String restaurantId);
}

class FavoritesRepoImpl implements FavoritesRepo {
  final Box<RestaurantModel> favoritesBox;

  FavoritesRepoImpl(this.favoritesBox);

  @override
  Future<Either<Failure, void>> addFavorite(RestaurantModel restaurant) async {
    try {
      await favoritesBox.put(restaurant.restaurantId, restaurant);
      return right(null);
    } catch (e) {
      return left(ServerFailure("Failed to add favorite: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String restaurantId) async {
    try {
      await favoritesBox.delete(restaurantId);
      return right(null);
    } catch (e) {
      return left(ServerFailure("Failed to remove favorite: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, List<RestaurantModel>>> getFavorites() async {
    try {
      final favorites = favoritesBox.values.toList();
      return right(favorites);
    } catch (e) {
      return left(ServerFailure("Failed to get favorites: ${e.toString()}"));
    }
  }

  @override
  bool isFavorite(String restaurantId) {
    return favoritesBox.containsKey(restaurantId);
  }
}
