import 'package:dinereserve/core/model/user_model.dart';
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

  Future<void> updateUserProfile({
    required String name,
    required String age,
    required UserModel currentUser,
    String? imagePath,
  }) async {
    emit(UserProfileUpdateLoading());

    String? imageUrl = currentUser.image;
    if (imagePath != null) {
      final uploadResult = await userProfileRepo.uploadProfileImage(imagePath);
      uploadResult.fold((failure) {
        emit(UserProfileUpdateError(failure.errMessage));
        return;
      }, (url) => imageUrl = url);
      if (state is UserProfileUpdateError) return;
    }

    final updatedUser = currentUser.copyWith(
      fullName: name,
      age: age,
      image: imageUrl,
    );

    final result = await userProfileRepo.updateUserProfile(updatedUser);
    result.fold((failure) => emit(UserProfileUpdateError(failure.errMessage)), (
      _,
    ) {
      emit(UserProfileUpdateSuccess());
      // Refresh profile data
      fetchUserProfile();
    });
  }
}
