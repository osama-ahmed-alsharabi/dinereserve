import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/router/app_router_const.dart';
import 'package:dinereserve/core/services/user_local_service.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/feature/booking/data/booking_repo.dart';
import 'package:dinereserve/feature/booking/presentation/view/widgets/user_booking_card.dart';
import 'package:dinereserve/feature/booking/presentation/view_model/booking_cubit.dart';
import 'package:dinereserve/feature/booking/presentation/view_model/booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserBookingsView extends StatelessWidget {
  const UserBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final userService = getIt.get<UserLocalService>();
        final user = userService.getUser();
        final cubit = BookingCubit(BookingRepoImpl(supabaseClient: getIt()));
        if (user != null) {
          cubit.loadUserBookings(user.id!);
        }
        return cubit;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'My Bookings',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            final userService = getIt.get<UserLocalService>();
            final user = userService.getUser();
            if (user != null) {
              context.read<BookingCubit>().loadUserBookings(user.id!);
            }
          },
          child: UserBookingsViewBodyWidget(),
        ),
      ),
    );
  }
}

class UserBookingsViewBodyWidget extends StatelessWidget {
  const UserBookingsViewBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        if (state is BookingLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        if (state is BookingError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Error loading bookings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (state is UserBookingsLoaded) {
          if (state.bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No Bookings Yet',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start booking your favorite restaurants!',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final userService = getIt.get<UserLocalService>();
              final user = userService.getUser();
              if (user != null) {
                context.read<BookingCubit>().loadUserBookings(user.fakeEmail!);
              }
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final booking = state.bookings[index];
                return UserBookingCard(
                  booking: booking,
                  onTap: () {
                    context.pushNamed(
                      AppRouterConst.bookingDetailViewRouteName,
                      extra: booking,
                    );
                  },
                );
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
