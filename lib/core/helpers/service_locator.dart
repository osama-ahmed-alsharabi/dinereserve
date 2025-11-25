import 'package:dinereserve/core/services/restaurant_local_service.dart';
import 'package:dinereserve/feature/user_profile/data/user_profile_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

setupServiceLocator() async {
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);
  getIt.registerSingleton<UserProfileRepo>(
    UserProfileRepoImpl(supabaseClient: getIt.get<SupabaseClient>()),
  );
  getIt.registerSingleton<RestaurantLocalService>(RestaurantLocalService());
}
