import 'dart:io';
import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/core/services/restaurant_local_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetRestaurantRepo {
  final SupabaseClient supabase;

  GetRestaurantRepo(this.supabase);

  Future<RestaurantModel> getRestaurantByOwner() async {
    final String ownerId = getIt
        .get<RestaurantLocalService>()
        .getRestaurant()!
        .ownerId!;
    final response = await supabase
        .from("restaurant")
        .select()
        .eq("owner_id", ownerId)
        .single();

    return RestaurantModel.fromMap(response);
  }

  Future<void> updateRestaurant(RestaurantModel restaurant) async {
    await supabase
        .from("restaurant")
        .update(restaurant.toMap())
        .eq("owner_id", restaurant.ownerId!);

    // Update local cache
    await getIt.get<RestaurantLocalService>().saveRestaurant(restaurant);
  }

  Future<String> uploadImage(String path) async {
    final fileName =
        'restaurant_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await supabase.storage
        .from('restaurant_images')
        .upload(
          fileName,
          File(path),
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
    final String publicUrl = supabase.storage
        .from('restaurant_images')
        .getPublicUrl(fileName);
    return publicUrl;
  }
}
