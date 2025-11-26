import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/services/user_local_service.dart';
import 'package:dinereserve/feature/auth/login/presentation/view/widgets/login_body_widget.dart';
import 'package:dinereserve/feature/auth/login/presentation/view_model/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        getIt.get<SupabaseClient>(),
        getIt.get<UserLocalService>(),
      ),
      child: Scaffold(body: LoginBodyWidget()),
    );
  }
}
