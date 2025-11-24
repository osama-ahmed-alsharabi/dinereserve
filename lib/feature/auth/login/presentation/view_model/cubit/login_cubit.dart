import 'package:dinereserve/core/errors/supabase_error_handler.dart';
import 'package:dinereserve/core/model/user_model.dart';
import 'package:dinereserve/feature/auth/login/presentation/view_model/cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginCubit extends Cubit<LoginState> {
  final SupabaseClient supabaseClient;
  LoginCubit(this.supabaseClient) : super(LoginInitial());

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
      final box = Hive.box("userBox");
      box.put("currentUser", userModel);

      emit(LoginSuccess(userName: userModel.fullName));
    } catch (e) {
      final errorMessage = SupabaseErrorHandler.parseAuthException(e);
      emit(LoginFaulier(errorMessage: errorMessage));
    }
  }
}
