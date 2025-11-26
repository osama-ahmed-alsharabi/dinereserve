import 'package:dinereserve/feature/home_rest/presentation/view/widgets/home_rest_view_body_widget.dart';
import 'package:dinereserve/feature/home_rest/presentation/view_model/home_rest_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeRestView extends StatelessWidget {
  const HomeRestView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeRestCubit()..fetchAds(),
      child: HomeRestViewBodyWidget(),
    );
  }
}
