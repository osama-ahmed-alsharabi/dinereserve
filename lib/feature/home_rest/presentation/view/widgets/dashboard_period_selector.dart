import 'package:dinereserve/feature/home_rest/presentation/view_model/dashboard_cubit.dart';
import 'package:flutter/material.dart';

class DashboardPeriodSelector extends StatelessWidget {
  final DashboardPeriod selectedPeriod;
  final Function(DashboardPeriod) onPeriodChanged;

  const DashboardPeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildPeriodChip(
            context,
            'Today',
            DashboardPeriod.today,
            Icons.today,
          ),
          const SizedBox(width: 8),
          _buildPeriodChip(
            context,
            'Week',
            DashboardPeriod.week,
            Icons.date_range,
          ),
          const SizedBox(width: 8),
          _buildPeriodChip(
            context,
            'Month',
            DashboardPeriod.month,
            Icons.calendar_month,
          ),
          const SizedBox(width: 8),
          _buildPeriodChip(
            context,
            'Year',
            DashboardPeriod.year,
            Icons.calendar_today,
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodChip(
    BuildContext context,
    String label,
    DashboardPeriod period,
    IconData icon,
  ) {
    final isSelected = selectedPeriod == period;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onPeriodChanged(period),
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.7),
                      ],
                    )
                  : null,
              color: isSelected ? null : Colors.grey.shade200,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
