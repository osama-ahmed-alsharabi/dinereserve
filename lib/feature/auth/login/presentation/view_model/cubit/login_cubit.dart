import 'dart:developer';

import 'package:dinereserve/core/errors/supabase_error_handler.dart';
import 'package:dinereserve/feature/auth/login/presentation/view_model/cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        password: password,
      );

      if (result.user == null) {
        throw Exception("Login failed");
      }
      emit(LoginSuccess());
    } catch (e) {
      log(e.toString());
      final errorMessage = SupabaseErrorHandler.parseAuthException(e);
      emit(LoginFaulier(errorMessage: errorMessage));
    }
  }
}
