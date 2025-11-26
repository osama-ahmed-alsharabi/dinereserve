import 'package:dinereserve/core/services/restaurant_local_service.dart';
import 'package:dinereserve/core/services/user_local_service.dart';
import 'package:dinereserve/feature/user_profile/data/user_profile_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

setupServiceLocator() async {
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);
  getIt.registerSingleton<UserLocalService>(UserLocalService());
  getIt.registerSingleton<RestaurantLocalService>(RestaurantLocalService());

  getIt.registerSingleton<UserProfileRepo>(
    UserProfileRepoImpl(
      supabaseClient: getIt.get<SupabaseClient>(),
      userLocalService: getIt.get<UserLocalService>(),
    ),
  );
}
