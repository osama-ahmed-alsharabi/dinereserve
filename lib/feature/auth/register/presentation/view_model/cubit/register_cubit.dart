import 'package:dinereserve/core/errors/supabase_error_handler.dart';
import 'package:dinereserve/core/model/user_model.dart';
import 'package:dinereserve/feature/auth/register/presentation/view_model/cubit/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final SupabaseClient supabaseClient;
  RegisterCubit(this.supabaseClient) : super(RegisterInitial());

  register(UserModel user) async {
    emit(RegisterLoading());
    try {
      final result = await supabaseClient.auth.signUp(
        email: user.fakeEmail,
        password: user.password!,
      );

      if (result.user == null) {
        throw Exception("Registration failed");
      }
      final userId = result.user!.id;
      await supabaseClient.from("profiles").insert({
        "id": userId,
        "full_name": user.fullName,
        "phone": user.phoneNumber,
        "age": user.age,
      });
      emit(RegisterSuccess());
    } catch (e) {
      final errorMessage = SupabaseErrorHandler.parseAuthException(e);
      emit(RegisterFailuer(errorMessage: errorMessage));
    }
  }
}
