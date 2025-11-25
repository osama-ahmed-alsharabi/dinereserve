import 'package:dinereserve/core/model/user_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserModel user;
  UserProfileLoaded(this.user);
}

class UserProfileError extends UserProfileState {
  final String errMessage;
  UserProfileError(this.errMessage);
}

class UserProfileLogoutLoading extends UserProfileState {}

class UserProfileLogoutSuccess extends UserProfileState {}

class UserProfileLogoutError extends UserProfileState {
  final String errMessage;
  UserProfileLogoutError(this.errMessage);
}

class UserProfileUpdateLoading extends UserProfileState {}

class UserProfileUpdateSuccess extends UserProfileState {}

class UserProfileUpdateError extends UserProfileState {
  final String errMessage;
  UserProfileUpdateError(this.errMessage);
}
