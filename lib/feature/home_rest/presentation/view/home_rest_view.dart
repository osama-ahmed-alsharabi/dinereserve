import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/services/restaurant_local_service.dart';
import 'package:dinereserve/feature/home_rest/data/dashboard_repo.dart';
import 'package:dinereserve/feature/home_rest/presentation/view/widgets/home_rest_view_body_widget.dart';
import 'package:dinereserve/feature/home_rest/presentation/view_model/dashboard_cubit.dart';
import 'package:dinereserve/feature/home_rest/presentation/view_model/home_rest_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeRestView extends StatelessWidget {
  const HomeRestView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeRestCubit()..fetchAds()),
        BlocProvider(
          create: (context) {
            final restaurant = getIt<RestaurantLocalService>().getRestaurant();
            final cubit = DashboardCubit(getIt<DashboardRepo>());
            if (restaurant != null && restaurant.restaurantId != null) {
              cubit.loadAnalytics(restaurant.restaurantId!);
            }
            return cubit;
          },
        ),
      ],
      child: HomeRestViewBodyWidget(),
    );
  }
}
