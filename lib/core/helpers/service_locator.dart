import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/core/model/user_model.dart';
import 'package:dinereserve/core/services/restaurant_local_service.dart';
import 'package:dinereserve/core/services/user_local_service.dart';
import 'package:dinereserve/feature/advertisement/data/advertisement_repo.dart';
import 'package:dinereserve/feature/favorites/data/favorites_repo.dart';
import 'package:dinereserve/feature/profile_restaurant/data/profile_restaurant_repo.dart';
import 'package:dinereserve/feature/user_profile/data/user_profile_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Hive Boxes
  final userBox = await Hive.openBox<UserModel>('user_box');
  final restaurantBox = await Hive.openBox<RestaurantModel>('restaurant_box');
  final favoritesBox = await Hive.openBox<RestaurantModel>('favorites_box');

  // Supabase
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Services
  getIt.registerLazySingleton<UserLocalService>(
    () => UserLocalService(userBox),
  );
  getIt.registerLazySingleton<RestaurantLocalService>(
    () => RestaurantLocalService(restaurantBox),
  );

  // Repositories
  getIt.registerLazySingleton<GetRestaurantRepo>(
    () => GetRestaurantRepo(getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<UserProfileRepo>(
    () =>
        UserProfileRepoImpl(supabaseClient: getIt(), userLocalService: getIt()),
  );
  getIt.registerLazySingleton<FavoritesRepo>(
    () => FavoritesRepoImpl(favoritesBox),
  );
  getIt.registerLazySingleton<AdvertisementRepo>(
    () => AdvertisementRepoImpl(supabaseClient: getIt()),
  );
}
