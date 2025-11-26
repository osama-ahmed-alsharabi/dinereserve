import 'package:dinereserve/core/errors/supabase_error_handler.dart';
import 'package:dinereserve/core/model/user_model.dart';
import 'package:dinereserve/core/services/user_local_service.dart';
import 'package:dinereserve/feature/auth/login/presentation/view_model/cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginCubit extends Cubit<LoginState> {
  final SupabaseClient supabaseClient;
  final UserLocalService userLocalService;

  LoginCubit(this.supabaseClient, this.userLocalService)
    : super(LoginInitial());

  void login({required String phone, required String password}) async {
    emit(LoginLoading());

    try {
      final fakeEmail = "user_$phone@auth.local";
      final result = await supabaseClient.auth.signInWithPassword(
        email: fakeEmail,
        password: password.trim(),
      );

      if (result.user == null) {
        throw Exception("Login failed");
      }

      final userId = result.user!.id;
      final response = await supabaseClient
          .from("profiles")
          .select()
          .eq("id", userId)
          .single();
      final userModel = UserModel.fromMap(
        response,
      ).copyWith(fakeEmail: fakeEmail, password: password);

      await userLocalService.saveUser(userModel);

      emit(LoginSuccess(userName: userModel.fullName));
    } catch (e) {
      final errorMessage = SupabaseErrorHandler.parseAuthException(e);
      emit(LoginFaulier(errorMessage: errorMessage));
    }
  }
}
