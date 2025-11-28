import 'package:dinereserve/core/model/dashboard_analytics_model.dart';
import 'package:flutter/material.dart';

class DashboardStatsCards extends StatelessWidget {
  final DashboardAnalyticsModel analytics;

  const DashboardStatsCards({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          context,
          icon: Icons.event_note,
          title: 'Total Bookings',
          value: analytics.totalBookings.toString(),
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        _buildStatCard(
          context,
          icon: Icons.check_circle,
          title: 'Confirmed',
          value: analytics.confirmedBookings.toString(),
          gradient: const LinearGradient(
            colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
          ),
        ),
        _buildStatCard(
          context,
          icon: Icons.trending_up,
          title: 'Acceptance Rate',
          value: '${analytics.acceptanceRate.toStringAsFixed(1)}%',
          gradient: const LinearGradient(
            colors: [Color(0xFFf093fb), Color(0xFFF5576C)],
          ),
        ),
        _buildStatCard(
          context,
          icon: Icons.table_restaurant,
          title: 'Total Tables',
          value: analytics.totalTables.toString(),
          gradient: const LinearGradient(
            colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Gradient gradient,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: animValue,
          child: Container(
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background icon
                Positioned(
                  right: -10,
                  top: -10,
                  child: Icon(
                    icon,
                    size: 80,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(icon, color: Colors.white, size: 28),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            title,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
