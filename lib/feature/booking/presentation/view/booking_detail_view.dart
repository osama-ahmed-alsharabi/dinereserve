import 'package:dinereserve/core/model/booking_model.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDetailView extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailView({super.key, required this.booking});

  Color _getStatusColor() {
    switch (booking.status) {
      case 'confirmed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Booking Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Status Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_getStatusColor(), _getStatusColor().withAlpha(179)],
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    booking.status == 'confirmed'
                        ? Icons.check_circle
                        : booking.status == 'rejected'
                        ? Icons.cancel
                        : booking.status == 'cancelled'
                        ? Icons.block
                        : Icons.schedule,
                    color: Colors.white,
                    size: 60,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    booking.status.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    booking.status == 'pending'
                        ? 'Waiting for restaurant confirmation'
                        : booking.status == 'confirmed'
                        ? 'Your booking is confirmed!'
                        : booking.status == 'rejected'
                        ? 'Booking was rejected'
                        : 'Booking was cancelled',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withAlpha(230),
                    ),
                  ),
                ],
              ),
            ),

            // Booking Details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Restaurant'),
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    icon: Icons.restaurant,
                    title: booking.restaurantName,
                    subtitle: 'Restaurant',
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Booking Information'),
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    icon: Icons.calendar_today,
                    title: DateFormat(
                      'EEEE, MMMM dd, yyyy',
                    ).format(booking.bookingDate),
                    subtitle: 'Date',
                  ),
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    icon: Icons.access_time,
                    title: booking.bookingTime,
                    subtitle: 'Time',
                  ),
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    icon: Icons.table_restaurant,
                    title:
                        '${booking.tableCount} ${booking.tableCount == 1 ? 'Table' : 'Tables'}',
                    subtitle: 'Tables Reserved',
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Payment'),
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    icon: Icons.payment,
                    title: booking.paymentMethodName,
                    subtitle: 'Payment Method',
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Contact Information'),
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    icon: Icons.person,
                    title: booking.userName,
                    subtitle: 'Name',
                  ),
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    icon: Icons.phone,
                    title: booking.userPhone,
                    subtitle: 'Phone',
                  ),
                  if (booking.createdAt != null) ...[
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'Booked on ${DateFormat('MMM dd, yyyy - hh:mm a').format(booking.createdAt!)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
