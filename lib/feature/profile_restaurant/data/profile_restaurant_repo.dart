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

  Future<List<RestaurantModel>> getAllRestaurants() async {
    final response = await supabase.from("restaurant").select();
    return (response as List).map((e) => RestaurantModel.fromMap(e)).toList();
  }

  Future<List<RestaurantModel>> getRestaurantsByType(String type) async {
    final response = await supabase
        .from("restaurant")
        .select()
        .eq("restaurant_type", type);
    return (response as List).map((e) => RestaurantModel.fromMap(e)).toList();
  }

  Future<List<RestaurantModel>> searchRestaurants({
    String? searchQuery,
    String? restaurantType,
    String? location,
    DateTime? date,
    String? time,
  }) async {
    var query = supabase.from("restaurant").select();

    // Filter by restaurant type (cuisine)
    if (restaurantType != null && restaurantType.isNotEmpty) {
      query = query.eq("restaurant_type", restaurantType);
    }

    // Filter by location
    if (location != null && location.isNotEmpty) {
      query = query.ilike("location", "%$location%");
    }

    final response = await query;
    List<RestaurantModel> restaurants = (response as List)
        .map((e) => RestaurantModel.fromMap(e))
        .toList();

    // Filter by name (client-side for case-insensitive partial match)
    if (searchQuery != null && searchQuery.isNotEmpty) {
      restaurants = restaurants.where((restaurant) {
        return restaurant.restaurantName.toLowerCase().contains(
          searchQuery.toLowerCase(),
        );
      }).toList();
    }

    // Filter by time availability
    if (time != null && time.isNotEmpty) {
      restaurants = restaurants.where((restaurant) {
        return _isRestaurantOpenAtTime(
          restaurant.openingTime,
          restaurant.closingTime,
          time,
        );
      }).toList();
    }

    // Filter by date and time availability (check bookings)
    if (date != null && time != null) {
      restaurants = await _filterByAvailability(restaurants, date, time);
    }

    return restaurants;
  }

  bool _isRestaurantOpenAtTime(
    String openingTime,
    String closingTime,
    String requestedTime,
  ) {
    try {
      final opening = _parseTime(openingTime);
      final closing = _parseTime(closingTime);
      final requested = _parseTime(requestedTime);

      return requested.isAfter(opening) && requested.isBefore(closing);
    } catch (e) {
      return true; // If parsing fails, don't filter out
    }
  }

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  Future<List<RestaurantModel>> _filterByAvailability(
    List<RestaurantModel> restaurants,
    DateTime date,
    String time,
  ) async {
    List<RestaurantModel> availableRestaurants = [];

    for (var restaurant in restaurants) {
      // Check if restaurant has available tables for the given date and time
      final bookingsResponse = await supabase
          .from('bookings')
          .select('table_count')
          .eq('restaurant_id', restaurant.restaurantId!)
          .eq('booking_date', date.toIso8601String().split('T')[0])
          .eq('booking_time', time);

      int bookedTables = 0;
      if (bookingsResponse.isNotEmpty) {
        for (var booking in bookingsResponse) {
          bookedTables += (booking['table_count'] as int?) ?? 0;
        }
      }

      // If there are available tables, include the restaurant
      if (bookedTables < restaurant.tablesCount) {
        availableRestaurants.add(restaurant);
      }
    }

    return availableRestaurants;
  }
}
