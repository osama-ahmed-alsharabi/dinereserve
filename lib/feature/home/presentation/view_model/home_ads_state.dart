import 'package:dinereserve/core/model/advertisement_model.dart';

abstract class HomeAdsState {}

class HomeAdsInitial extends HomeAdsState {}

class HomeAdsLoading extends HomeAdsState {}

class HomeAdsLoaded extends HomeAdsState {
  final List<AdvertisementModel> ads;
  HomeAdsLoaded(this.ads);
}

class HomeAdsError extends HomeAdsState {
  final String message;
  HomeAdsError(this.message);
}

class HomeAdsEmpty extends HomeAdsState {}
