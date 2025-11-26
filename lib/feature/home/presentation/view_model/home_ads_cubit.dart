import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/feature/advertisement/data/advertisement_repo.dart';
import 'package:dinereserve/feature/home/presentation/view_model/home_ads_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeAdsCubit extends Cubit<HomeAdsState> {
  HomeAdsCubit() : super(HomeAdsInitial());

  final _repo = AdvertisementRepoImpl(
    supabaseClient: getIt.get<SupabaseClient>(),
  );

  Future<void> fetchActiveAds() async {
    emit(HomeAdsLoading());
    final result = await _repo.fetchAllActiveAdvertisements();
    result.fold((failure) => emit(HomeAdsError(failure.errMessage)), (ads) {
      if (ads.isEmpty) {
        emit(HomeAdsEmpty());
      } else {
        emit(HomeAdsLoaded(ads));
      }
    });
  }
}
