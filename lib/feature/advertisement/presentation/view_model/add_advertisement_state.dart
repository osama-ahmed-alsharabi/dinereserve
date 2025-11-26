import 'dart:io';

abstract class AddAdvertisementState {}

class AddAdvertisementInitial extends AddAdvertisementState {}

class AddAdvertisementLoading extends AddAdvertisementState {}

class AddAdvertisementSuccess extends AddAdvertisementState {}

class AddAdvertisementFailure extends AddAdvertisementState {
  final String message;
  AddAdvertisementFailure(this.message);
}

class AddAdvertisementImageSelected extends AddAdvertisementState {
  final File image;
  AddAdvertisementImageSelected(this.image);
}

class AddAdvertisementDateSelected extends AddAdvertisementState {
  final DateTime? startDate;
  final DateTime? endDate;
  AddAdvertisementDateSelected({this.startDate, this.endDate});
}
