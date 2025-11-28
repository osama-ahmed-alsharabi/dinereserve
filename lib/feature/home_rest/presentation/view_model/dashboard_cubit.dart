import 'package:dinereserve/feature/home_rest/data/dashboard_repo.dart';
import 'package:dinereserve/feature/home_rest/presentation/view_model/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum DashboardPeriod { today, week, month, year }

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepo dashboardRepo;
  String? _currentRestaurantId;
  DashboardPeriod _currentPeriod = DashboardPeriod.week;

  DashboardCubit(this.dashboardRepo) : super(DashboardInitial());

  /// Load analytics for a restaurant with the current period
  Future<void> loadAnalytics(String restaurantId) async {
    _currentRestaurantId = restaurantId;
    await _fetchAnalytics();
  }

  /// Change the period and reload analytics
  Future<void> changePeriod(DashboardPeriod period) async {
    if (_currentRestaurantId == null) return;

    _currentPeriod = period;
    await _fetchAnalytics();
  }

  /// Refresh analytics with the current settings
  Future<void> refreshAnalytics() async {
    if (_currentRestaurantId == null) return;
    await _fetchAnalytics();
  }

  /// Internal method to fetch analytics based on current settings
  Future<void> _fetchAnalytics() async {
    if (_currentRestaurantId == null) return;

    emit(DashboardLoading());

    final dateRange = _getDateRange(_currentPeriod);
    final result = await dashboardRepo.getRestaurantAnalytics(
      _currentRestaurantId!,
      dateRange.start,
      dateRange.end,
    );

    result.fold(
      (failure) => emit(DashboardError(failure.errMessage)),
      (analytics) => emit(
        DashboardLoaded(
          analytics: analytics,
          period: _getPeriodName(_currentPeriod),
        ),
      ),
    );
  }

  /// Get date range based on selected period
  DateRange _getDateRange(DashboardPeriod period) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (period) {
      case DashboardPeriod.today:
        return DateRange(start: today, end: today);
      case DashboardPeriod.week:
        final weekAgo = today.subtract(const Duration(days: 7));
        return DateRange(start: weekAgo, end: today);
      case DashboardPeriod.month:
        final monthAgo = DateTime(now.year, now.month - 1, now.day);
        return DateRange(start: monthAgo, end: today);
      case DashboardPeriod.year:
        final yearAgo = DateTime(now.year - 1, now.month, now.day);
        return DateRange(start: yearAgo, end: today);
    }
  }

  /// Get period name for display
  String _getPeriodName(DashboardPeriod period) {
    switch (period) {
      case DashboardPeriod.today:
        return 'Today';
      case DashboardPeriod.week:
        return 'This Week';
      case DashboardPeriod.month:
        return 'This Month';
      case DashboardPeriod.year:
        return 'This Year';
    }
  }

  DashboardPeriod get currentPeriod => _currentPeriod;
}

class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange({required this.start, required this.end});
}
