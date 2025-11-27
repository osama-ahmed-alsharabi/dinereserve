import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/services/restaurant_local_service.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/feature/booking/data/booking_repo.dart';
import 'package:dinereserve/feature/booking/presentation/view/widgets/restaurant_booking_card.dart';
import 'package:dinereserve/feature/booking/presentation/view_model/booking_cubit.dart';
import 'package:dinereserve/feature/booking/presentation/view_model/booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestaurantBookingsView extends StatefulWidget {
  const RestaurantBookingsView({super.key});

  @override
  State<RestaurantBookingsView> createState() => _RestaurantBookingsViewState();
}

class _RestaurantBookingsViewState extends State<RestaurantBookingsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final restaurantService = getIt.get<RestaurantLocalService>();
        final restaurant = restaurantService.getRestaurant();
        final cubit = BookingCubit(BookingRepoImpl(supabaseClient: getIt()));
        if (restaurant != null) {
          cubit.loadRestaurantBookings(restaurant.restaurantId!);
        }
        return cubit;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Bookings',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primaryColor,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Pending'),
              Tab(text: 'Confirmed'),
              Tab(text: 'All'),
            ],
          ),
        ),
        body: BlocConsumer<BookingCubit, BookingState>(
          listener: (context, state) {
            if (state is BookingStatusUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Booking ${state.newStatus}'),
                  backgroundColor: state.newStatus == 'confirmed'
                      ? Colors.green
                      : Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              // Reload bookings
              final restaurantService = getIt.get<RestaurantLocalService>();
              final restaurant = restaurantService.getRestaurant();
              if (restaurant != null) {
                context.read<BookingCubit>().loadRestaurantBookings(
                  restaurant.restaurantId!,
                );
              }
            }
          },
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
                  ],
                ),
              );
            }

            if (state is RestaurantBookingsLoaded) {
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildBookingsList(
                    state.bookings.where((b) => b.status == 'pending').toList(),
                    'No pending bookings',
                  ),
                  _buildBookingsList(
                    state.bookings
                        .where((b) => b.status == 'confirmed')
                        .toList(),
                    'No confirmed bookings',
                  ),
                  _buildBookingsList(state.bookings, 'No bookings yet'),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildBookingsList(List bookings, String emptyMessage) {
    if (bookings.isEmpty) {
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
              emptyMessage,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final restaurantService = getIt.get<RestaurantLocalService>();
        final restaurant = restaurantService.getRestaurant();
        if (restaurant != null) {
          context.read<BookingCubit>().loadRestaurantBookings(
            restaurant.restaurantId!,
          );
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return RestaurantBookingCard(
            booking: booking,
            onConfirm: booking.status == 'pending'
                ? () => _showConfirmDialog(context, booking.id!, 'confirmed')
                : null,
            onReject: booking.status == 'pending'
                ? () => _showConfirmDialog(context, booking.id!, 'rejected')
                : null,
          );
        },
      ),
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    String bookingId,
    String newStatus,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          newStatus == 'confirmed' ? 'Confirm Booking?' : 'Reject Booking?',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          newStatus == 'confirmed'
              ? 'Are you sure you want to confirm this booking?'
              : 'Are you sure you want to reject this booking?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<BookingCubit>().updateBookingStatus(
                bookingId,
                newStatus,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: newStatus == 'confirmed'
                  ? Colors.green
                  : Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(newStatus == 'confirmed' ? 'Confirm' : 'Reject'),
          ),
        ],
      ),
    );
  }
}
