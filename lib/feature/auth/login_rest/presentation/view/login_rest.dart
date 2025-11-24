import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/feature/auth/login_rest/presentation/view/widgets/login_restaurant_body_widget.dart';
import 'package:dinereserve/feature/auth/login_rest/presentation/view_model/cubit/login_restaurant_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginRestView extends StatelessWidget {
  const LoginRestView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginRestaurantCubit(getIt.get<SupabaseClient>()),
      child: Scaffold(body: LoginRestaurantBodyWidget()),
    );
  }
}
