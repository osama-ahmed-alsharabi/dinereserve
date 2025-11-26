import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/model/advertisement_model.dart';
import 'package:dinereserve/core/services/restaurant_local_service.dart';
import 'package:dinereserve/feature/advertisement/data/advertisement_repo.dart';
import 'package:dinereserve/feature/home_rest/presentation/view_model/home_rest_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeRestCubit extends Cubit<HomeRestState> {
  HomeRestCubit() : super(HomeRestInitial());

  final _repo = AdvertisementRepoImpl(
    supabaseClient: getIt.get<SupabaseClient>(),
  );

  Future<void> fetchAds() async {
    emit(HomeRestLoading());
    final restaurant = getIt.get<RestaurantLocalService>().getRestaurant();
    if (restaurant == null) {
      emit(HomeRestError("Restaurant not logged in"));
      return;
    }

    final result = await _repo.fetchAdvertisements(
      restaurant.restaurantId ?? "",
    );
    result.fold((failure) => emit(HomeRestError(failure.errMessage)), (ads) {
      if (ads.isEmpty) {
        emit(HomeRestEmpty());
      } else {
        emit(HomeRestLoaded(ads));
      }
    });
  }

  Future<void> deleteAd(String adId, String imageUrl) async {
    // Optimistic update or reload? Let's reload for safety.
    // Or we can emit loading, delete, then fetch again.
    emit(HomeRestLoading());
    final result = await _repo.deleteAdvertisement(adId, imageUrl);
    result.fold(
      (failure) => emit(HomeRestError(failure.errMessage)),
      (_) => fetchAds(),
    );
  }

  Future<void> updateAd(AdvertisementModel ad) async {
    emit(HomeRestLoading());
    final result = await _repo.updateAdvertisement(ad);
    result.fold(
      (failure) => emit(HomeRestError(failure.errMessage)),
      (_) => fetchAds(),
    );
  }
}
