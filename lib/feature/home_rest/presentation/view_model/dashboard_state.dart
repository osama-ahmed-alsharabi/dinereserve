import 'package:dinereserve/core/model/dashboard_analytics_model.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardAnalyticsModel analytics;
  final String period;

  DashboardLoaded({required this.analytics, required this.period});
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}
