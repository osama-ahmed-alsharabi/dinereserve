import 'package:dinereserve/feature/home_rest/presentation/view/widgets/bookings_status_chart.dart';
import 'package:dinereserve/feature/home_rest/presentation/view/widgets/bookings_trend_chart.dart';
import 'package:dinereserve/feature/home_rest/presentation/view/widgets/dashboard_period_selector.dart';
import 'package:dinereserve/feature/home_rest/presentation/view/widgets/dashboard_stats_cards.dart';
import 'package:dinereserve/feature/home_rest/presentation/view/widgets/peak_hours_chart.dart';
import 'package:dinereserve/feature/home_rest/presentation/view_model/dashboard_cubit.dart';
import 'package:dinereserve/feature/home_rest/presentation/view_model/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RestaurantDashboardWidget extends StatelessWidget {
  const RestaurantDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return _buildLoadingSkeleton();
        }

        if (state is DashboardError) {
          return _buildError(context, state.message);
        }

        if (state is DashboardLoaded) {
          return _buildDashboard(context, state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDashboard(BuildContext context, DashboardLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.analytics, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analytics Dashboard',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Comprehensive analysis of your bookings',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Period Selector
        DashboardPeriodSelector(
          selectedPeriod: context.read<DashboardCubit>().currentPeriod,
          onPeriodChanged: (period) {
            context.read<DashboardCubit>().changePeriod(period);
          },
        ),
        const SizedBox(height: 20),

        // Statistics Cards
        DashboardStatsCards(analytics: state.analytics),
        const SizedBox(height: 20),

        // Bookings Status Chart
        BookingsStatusChart(analytics: state.analytics),
        const SizedBox(height: 20),

        // Bookings Trend Chart
        BookingsTrendChart(analytics: state.analytics),
        const SizedBox(height: 20),

        // Peak Hours Chart
        PeakHoursChart(analytics: state.analytics),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLoadingSkeleton() {
    return Skeletonizer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: List.generate(
              4,
              (index) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Error occurred',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(message, style: TextStyle(color: Colors.red.shade700)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<DashboardCubit>().refreshAnalytics();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
