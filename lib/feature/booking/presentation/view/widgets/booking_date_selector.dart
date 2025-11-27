import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDateSelector extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const BookingDateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: selectedDate != null
              ? const LinearGradient(
                  colors: [AppColors.primaryColor, Color(0xFFFF8A65)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: selectedDate == null ? Colors.grey[100] : null,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selectedDate != null
                ? AppColors.primaryColor
                : Colors.grey.withAlpha(51),
            width: selectedDate != null ? 2 : 1,
          ),
          boxShadow: selectedDate != null
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withAlpha(77),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: selectedDate != null
                    ? Colors.white.withAlpha(51)
                    : AppColors.primaryColor.withAlpha(26),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.calendar_today,
                color: selectedDate != null
                    ? Colors.white
                    : AppColors.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Booking Date",
                    style: TextStyle(
                      fontSize: 12,
                      color: selectedDate != null
                          ? Colors.white.withAlpha(204)
                          : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedDate != null
                        ? DateFormat('EEEE, MMM dd, yyyy').format(selectedDate!)
                        : "Select Date",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: selectedDate != null
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: selectedDate != null ? Colors.white : Colors.grey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
