import 'package:dinereserve/core/model/advertisement_model.dart';

abstract class HomeRestState {}

class HomeRestInitial extends HomeRestState {}

class HomeRestLoading extends HomeRestState {}

class HomeRestLoaded extends HomeRestState {
  final List<AdvertisementModel> ads;
  HomeRestLoaded(this.ads);
}

class HomeRestError extends HomeRestState {
  final String message;
  HomeRestError(this.message);
}

class HomeRestEmpty extends HomeRestState {}
