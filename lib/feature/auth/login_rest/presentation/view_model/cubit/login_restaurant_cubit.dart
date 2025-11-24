import 'package:dinereserve/core/errors/supabase_error_handler.dart';
import 'package:dinereserve/feature/auth/login_rest/presentation/view_model/cubit/login_restaurant_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginRestaurantCubit extends Cubit<LoginRestaurantState> {
  final SupabaseClient supabaseClient;
  LoginRestaurantCubit(this.supabaseClient) : super(LoginRestaurantInitial());

  void login({required String phone, required String password}) async {
    emit(LoginRestaurantLoading());

    try {
      final fakeEmail = "restaurant_$phone@auth.local";
      final result = await supabaseClient.auth.signInWithPassword(
        email: fakeEmail,
        password: password.trim(),
      );
      if (result.user == null) {
        throw Exception("Login failed");
      }
      emit(LoginRestaurantSuccess());
    } catch (e) {
      final errorMessage = SupabaseErrorHandler.parseAuthException(e);
      emit(LoginRestaurantFaulier(errorMessage: errorMessage));
    }
  }
}
