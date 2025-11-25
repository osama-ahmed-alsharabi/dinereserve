import 'package:dinereserve/feature/user_profile/data/user_profile_repo.dart';
import 'package:dinereserve/feature/user_profile/presentation/view_model/user_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final UserProfileRepo userProfileRepo;

  UserProfileCubit(this.userProfileRepo) : super(UserProfileInitial());

  Future<void> fetchUserProfile() async {
    emit(UserProfileLoading());
    final result = await userProfileRepo.getUserProfile();
    result.fold(
      (failure) => emit(UserProfileError(failure.errMessage)),
      (user) => emit(UserProfileLoaded(user)),
    );
  }

  Future<void> logout() async {
    emit(UserProfileLogoutLoading());
    final result = await userProfileRepo.logout();
    result.fold(
      (failure) => emit(UserProfileLogoutError(failure.errMessage)),
      (_) => emit(UserProfileLogoutSuccess()),
    );
  }
}
