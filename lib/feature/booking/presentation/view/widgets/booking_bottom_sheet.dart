import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/model/booking_model.dart';
import 'package:dinereserve/core/model/payment_method_model.dart';
import 'package:dinereserve/core/model/restaurant_model.dart';
import 'package:dinereserve/core/model/user_model.dart';
import 'package:dinereserve/core/services/payment_method_local_service.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/feature/booking/presentation/view/widgets/booking_date_selector.dart';
import 'package:dinereserve/feature/booking/presentation/view/widgets/booking_summary_card.dart';
import 'package:dinereserve/feature/booking/presentation/view/widgets/booking_table_count_selector.dart';
import 'package:dinereserve/feature/booking/presentation/view/widgets/booking_time_selector.dart';
import 'package:dinereserve/feature/booking/presentation/view_model/booking_cubit.dart';
import 'package:dinereserve/feature/booking/presentation/view_model/booking_state.dart';
import 'package:dinereserve/feature/user_profile/presentation/view/widgets/payment_method_bottom_sheet.dart';
import 'package:dinereserve/feature/user_profile/presentation/view_model/payment_method_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingBottomSheet extends StatefulWidget {
  final RestaurantModel restaurant;
  final UserModel user;

  const BookingBottomSheet({
    super.key,
    required this.restaurant,
    required this.user,
  });

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  DateTime? selectedDate;
  String? selectedTime;
  int tableCount = 1;
  PaymentMethodModel? selectedPaymentMethod;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethod();
  }

  void _loadPaymentMethod() {
    final paymentService = getIt.get<PaymentMethodLocalService>();
    selectedPaymentMethod = paymentService.getPaymentMethod();
  }

  void _showPaymentMethodSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) =>
            PaymentMethodCubit(getIt.get<PaymentMethodLocalService>())
              ..loadPaymentMethod(),
        child: const PaymentMethodBottomSheet(),
      ),
    ).then((_) {
      setState(() {
        _loadPaymentMethod();
      });
    });
  }

  bool _isTimeValid(String time) {
    if (selectedDate == null) return false;
    return context.read<BookingCubit>().validateBookingTime(
      bookingDate: selectedDate!,
      bookingTime: time,
      restaurantOpenTime: widget.restaurant.openingTime,
      restaurantCloseTime: widget.restaurant.closingTime,
    );
  }

  bool _canProceed() {
    switch (currentStep) {
      case 0:
        return selectedDate != null;
      case 1:
        return selectedTime != null;
      case 2:
        return tableCount > 0;
      case 3:
        return selectedPaymentMethod != null;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (currentStep < 3) {
      setState(() {
        currentStep++;
      });
    } else {
      _createBooking();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  void _createBooking() {
    if (selectedDate == null ||
        selectedTime == null ||
        selectedPaymentMethod == null) {
      return;
    }

    final booking = BookingModel(
      userId: widget.user.id!,
      userName: widget.user.fullName,
      userPhone: widget.user.phoneNumber,
      restaurantId: widget.restaurant.restaurantId!,
      restaurantName: widget.restaurant.restaurantName,
      bookingDate: selectedDate!,
      bookingTime: selectedTime!,
      tableCount: tableCount,
      paymentMethodId: selectedPaymentMethod!.id,
      paymentMethodName: selectedPaymentMethod!.name,
    );

    context.read<BookingCubit>().createBooking(booking);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingCreated) {
          Navigator.pop(context);
          _showSuccessDialog();
        } else if (state is BookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildStepIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildStepContent(),
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.restaurant.restaurantName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Book a Table",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index == currentStep;
          final isCompleted = index < currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
              decoration: BoxDecoration(
                color: isCompleted || isActive
                    ? AppColors.primaryColor
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Step 1: Select Date",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            BookingDateSelector(
              selectedDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                  selectedTime = null; // Reset time when date changes
                });
              },
            ),
          ],
        );
      case 1:
        return BookingTimeSelector(
          selectedTime: selectedTime,
          onTimeSelected: (time) {
            setState(() {
              selectedTime = time;
            });
          },
          isTimeValid: _isTimeValid,
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Step 3: Number of Tables",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            BookingTableCountSelector(
              tableCount: tableCount,
              maxTables: widget.restaurant.tablesCount,
              onCountChanged: (count) {
                setState(() {
                  tableCount = count;
                });
              },
            ),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Step 4: Review & Payment",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            if (selectedDate != null && selectedTime != null) ...[
              if (selectedPaymentMethod != null)
                BookingSummaryCard(
                  booking: BookingModel(
                    userId: widget.user.id!,
                    userName: widget.user.fullName,
                    userPhone: widget.user.phoneNumber,
                    restaurantId: widget.restaurant.restaurantId!,
                    restaurantName: widget.restaurant.restaurantName,
                    bookingDate: selectedDate!,
                    bookingTime: selectedTime!,
                    tableCount: tableCount,
                    paymentMethodId: selectedPaymentMethod!.id,
                    paymentMethodName: selectedPaymentMethod!.name,
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.payment, color: Colors.grey),
                      SizedBox(width: 12),
                      Text(
                        "No payment method selected",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showPaymentMethodSheet,
                  icon: const Icon(Icons.credit_card),
                  label: Text(
                    selectedPaymentMethod == null
                        ? "Select Payment Method"
                        : "Change Payment Method",
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Back",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: currentStep == 0 ? 1 : 2,
            child: BlocBuilder<BookingCubit, BookingState>(
              builder: (context, state) {
                final isLoading = state is BookingLoading;
                return ElevatedButton(
                  onPressed: _canProceed() && !isLoading ? _nextStep : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shadowColor: AppColors.primaryColor.withAlpha(102),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          currentStep == 3 ? "Confirm Booking" : "Next",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Booking Confirmed!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Your table has been reserved at ${widget.restaurant.restaurantName}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Done",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
