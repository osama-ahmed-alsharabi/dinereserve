import 'dart:developer';

import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/core/model/restaurant_search_filter.dart';
import 'package:dinereserve/feature/profile_restaurant/data/profile_restaurant_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class RestaurantSearchState {}

class RestaurantSearchInitial extends RestaurantSearchState {}

class RestaurantSearchLoading extends RestaurantSearchState {}

class RestaurantSearchSuccess extends RestaurantSearchState {
  final List<RestaurantModel> restaurants;
  final RestaurantSearchFilter filter;

  RestaurantSearchSuccess(this.restaurants, this.filter);
}

class RestaurantSearchEmpty extends RestaurantSearchState {
  final RestaurantSearchFilter filter;

  RestaurantSearchEmpty(this.filter);
}

class RestaurantSearchError extends RestaurantSearchState {
  final String message;

  RestaurantSearchError(this.message);
}

class RestaurantSearchCubit extends Cubit<RestaurantSearchState> {
  final GetRestaurantRepo repo;
  RestaurantSearchFilter currentFilter = RestaurantSearchFilter();

  RestaurantSearchCubit(this.repo) : super(RestaurantSearchInitial());

  Future<void> searchRestaurants(RestaurantSearchFilter filter) async {
    currentFilter = filter;
    emit(RestaurantSearchLoading());

    try {
      log('🔍 Starting search with filters:');
      log('  - Query: ${filter.searchQuery}');
      log('  - Type: ${filter.restaurantType}');
      log('  - Location: ${filter.location}');
      log('  - Date: ${filter.date}');
      log('  - Time: ${filter.time}');

      final restaurants = await repo.searchRestaurants(
        searchQuery: filter.searchQuery,
        restaurantType: filter.restaurantType,
        location: filter.location,
        date: filter.date,
        time: filter.time,
      );

      log('✅ Search completed. Found ${restaurants.length} restaurants');

      if (restaurants.isEmpty) {
        emit(RestaurantSearchEmpty(filter));
      } else {
        emit(RestaurantSearchSuccess(restaurants, filter));
      }
    } catch (e, stackTrace) {
      log('❌ Search error: $e');
      log('Stack trace: $stackTrace');
      emit(RestaurantSearchError(e.toString()));
    }
  }

  void clearFilters() {
    currentFilter = RestaurantSearchFilter();
    emit(RestaurantSearchInitial());
  }

  void updateFilter(RestaurantSearchFilter filter) {
    currentFilter = filter;
  }
}
