import 'package:dinereserve/core/model/notification_model.dart';
import 'package:dinereserve/core/model/payment_method_model.dart';
import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/core/model/user_model.dart';
import 'package:dinereserve/core/services/payment_method_local_service.dart';
import 'package:dinereserve/core/services/restaurant_local_service.dart';
import 'package:dinereserve/core/services/user_local_service.dart';
import 'package:dinereserve/feature/advertisement/data/advertisement_repo.dart';
import 'package:dinereserve/feature/favorites/data/favorites_repo.dart';
import 'package:dinereserve/feature/profile_restaurant/data/profile_restaurant_repo.dart';
import 'package:dinereserve/feature/user_profile/data/user_profile_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:dinereserve/feature/notification/data/notification_repo.dart';
import 'package:dinereserve/feature/home_rest/data/dashboard_repo.dart';
import 'package:dinereserve/feature/booking/data/booking_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Hive Boxes
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(RestaurantModelAdapter());
  Hive.registerAdapter(PaymentMethodModelAdapter());
  Hive.registerAdapter(NotificationModelAdapter());

  final userBox = await Hive.openBox<UserModel>('user_box');
  final restaurantBox = await Hive.openBox<RestaurantModel>('restaurant_box');
  final favoritesBox = await Hive.openBox<RestaurantModel>('favorites_box');
  final paymentMethodBox = await Hive.openBox<PaymentMethodModel>(
    'payment_method_box',
  );

  // Supabase
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Services
  getIt.registerLazySingleton<UserLocalService>(
    () => UserLocalService(userBox),
  );
  getIt.registerLazySingleton<RestaurantLocalService>(
    () => RestaurantLocalService(restaurantBox),
  );
  getIt.registerLazySingleton<PaymentMethodLocalService>(
    () => PaymentMethodLocalService(paymentMethodBox),
  );

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

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
  getIt.registerLazySingleton<NotificationRepo>(
    () => NotificationRepo(getIt<SupabaseClient>()),
  );

  // Dashboard Repository
  getIt.registerLazySingleton<DashboardRepo>(
    () => DashboardRepoImpl(supabaseClient: getIt()),
  );

  // Booking Repository
  getIt.registerLazySingleton<BookingRepo>(
    () => BookingRepoImpl(supabaseClient: getIt()),
  );
}
