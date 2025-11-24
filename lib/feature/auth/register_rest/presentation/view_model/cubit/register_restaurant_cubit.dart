import 'dart:developer';
import 'package:dinereserve/core/errors/supabase_error_handler.dart';
import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/feature/auth/register_rest/presentation/view_model/cubit/register_restaurant_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterRestaurantCubit extends Cubit<RegisterRestaurantState> {
  final SupabaseClient supabaseClient;

  RegisterRestaurantCubit(this.supabaseClient)
    : super(RegisterRestaurantInitial());

  Future<void> register(RestaurantModel restaurantModel) async {
    emit(RegisterRestaurantLoading());

    try {
      final fakeEmail =
          "restaurant_${restaurantModel.restaurantPhone}@auth.local";

      final result = await supabaseClient.auth.signUp(
        email: fakeEmail,
        password: restaurantModel.password!,
      );
      if (result.user == null) {
        throw Exception("Registration failed");
      }
      final userId = result.user!.id;
      final newModel = restaurantModel.copyWith(
        ownerId: userId,
        fakeEmail: fakeEmail,
      );
      await supabaseClient.from("restaurant").insert(newModel.toMap());
      emit(RegisterRestaurantSuccess());
    } catch (e) {
      log(e.toString());
      final errorMessage = SupabaseErrorHandler.parseAuthException(e);
      emit(RegisterRestaurantFaulier(errorMessage: errorMessage));
    }
  }
}
