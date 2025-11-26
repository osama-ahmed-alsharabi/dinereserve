import 'package:dinereserve/core/errors/supabase_error_handler.dart';
import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/core/services/restaurant_local_service.dart';
import 'package:dinereserve/feature/auth/login_rest/presentation/view_model/cubit/login_restaurant_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginRestaurantCubit extends Cubit<LoginRestaurantState> {
  final SupabaseClient supabaseClient;
  final RestaurantLocalService restaurantLocalService;

  LoginRestaurantCubit(this.supabaseClient, this.restaurantLocalService)
    : super(LoginRestaurantInitial());

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
      final userId = result.user!.id;
      final response = await supabaseClient
          .from("restaurant")
          .select()
          .eq("owner_id", userId)
          .single();
      RestaurantModel restaurantModel = RestaurantModel.fromMap(response);

      await restaurantLocalService.saveRestaurant(restaurantModel);

      emit(LoginRestaurantSuccess(restaurantModel: restaurantModel));
    } catch (e) {
      final errorMessage = SupabaseErrorHandler.parseAuthException(e);
      emit(LoginRestaurantFaulier(errorMessage: errorMessage));
    }
  }
}
