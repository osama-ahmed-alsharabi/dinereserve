import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/feature/auth/register/presentation/view/widgets/register_body_widget.dart';
import 'package:dinereserve/feature/auth/register/presentation/view_model/cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(getIt.get<SupabaseClient>()),
      child: Scaffold(body: RegiserBodyWidget()),
    );
  }
}
