import 'package:dinereserve/core/model/dashboard_analytics_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BookingsStatusChart extends StatelessWidget {
  final DashboardAnalyticsModel analytics;

  const BookingsStatusChart({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Status Distribution',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: analytics.totalBookings > 0
                ? PieChart(
                    PieChartData(
                      sections: _buildSections(),
                      centerSpaceRadius: 50,
                      sectionsSpace: 2,
                      pieTouchData: PieTouchData(
                        touchCallback:
                            (FlTouchEvent event, pieTouchResponse) {},
                      ),
                    ),
                  )
                : const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          _buildLegend(),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final total = analytics.totalBookings.toDouble();
    if (total == 0) return [];

    return [
      if (analytics.confirmedBookings > 0)
        PieChartSectionData(
          value: analytics.confirmedBookings.toDouble(),
          title:
              '${(analytics.confirmedBookings / total * 100).toStringAsFixed(0)}%',
          color: const Color(0xFF11998e),
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      if (analytics.pendingBookings > 0)
        PieChartSectionData(
          value: analytics.pendingBookings.toDouble(),
          title:
              '${(analytics.pendingBookings / total * 100).toStringAsFixed(0)}%',
          color: const Color(0xFFf093fb),
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      if (analytics.rejectedBookings > 0)
        PieChartSectionData(
          value: analytics.rejectedBookings.toDouble(),
          title:
              '${(analytics.rejectedBookings / total * 100).toStringAsFixed(0)}%',
          color: const Color(0xFFF5576C),
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      if (analytics.cancelledBookings > 0)
        PieChartSectionData(
          value: analytics.cancelledBookings.toDouble(),
          title:
              '${(analytics.cancelledBookings / total * 100).toStringAsFixed(0)}%',
          color: const Color(0xFF95a5a6),
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
    ];
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        if (analytics.confirmedBookings > 0)
          _buildLegendItem(
            'Confirmed',
            const Color(0xFF11998e),
            analytics.confirmedBookings,
          ),
        if (analytics.pendingBookings > 0)
          _buildLegendItem(
            'Pending',
            const Color(0xFFf093fb),
            analytics.pendingBookings,
          ),
        if (analytics.rejectedBookings > 0)
          _buildLegendItem(
            'Rejected',
            const Color(0xFFF5576C),
            analytics.rejectedBookings,
          ),
        if (analytics.cancelledBookings > 0)
          _buildLegendItem(
            'Cancelled',
            const Color(0xFF95a5a6),
            analytics.cancelledBookings,
          ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text('$label ($count)', style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
