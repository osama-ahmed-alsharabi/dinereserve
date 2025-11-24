import 'package:hive/hive.dart';
import 'package:dinereserve/core/model/restaurant_model.dart';

class RestaurantLocalService {
  static const String restaurantBoxName = "restaurantBox";
  static const String restaurantKey = "currentRestaurant";

  final Box box = Hive.box(restaurantBoxName);

  /// Save restaurant data
  Future<void> saveRestaurant(RestaurantModel restaurant) async {
    await box.put(restaurantKey, restaurant);
  }

  /// Get saved restaurant
  RestaurantModel? getRestaurant() {
    return box.get(restaurantKey);
  }

  /// Check if restaurant is logged in
  bool isRestaurantLoggedIn() {
    return box.get(restaurantKey) != null;
  }

  /// Logout (delete restaurant data)
  Future<void> logout() async {
    await box.delete(restaurantKey);
  }
}
