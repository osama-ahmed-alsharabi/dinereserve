import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/feature/auth/register_rest/presentation/view/widgets/register_rest_bloc_consumer_widget.dart';
import 'package:dinereserve/feature/auth/register_rest/presentation/view_model/cubit/register_restaurant_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterRestView extends StatelessWidget {
  const RegisterRestView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterRestaurantCubit(getIt.get<SupabaseClient>()),
      child: Scaffold(body: RegisterRestBlocConsumerWidget()),
    );
  }
}