import 'package:flutter/material.dart';
import 'package:playarena/models/common/booking_model.dart';
import 'package:playarena/utils/date_time_helper.dart';

class OwnerBookingCard extends StatelessWidget {
  final BookingModel booking;

  const OwnerBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: Colors.indigo),
        title: Text(
          '${booking.userName} • ₹${booking.amountPaid}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          DateTimeHelper.formatDateTimeRange(
              booking.startTime, booking.endTime),
          style: const TextStyle(color: Colors.grey),
        ),
        isThreeLine: true,
        trailing: Icon(
          booking.status == 'confirmed'
              ? Icons.check_circle
              : Icons.hourglass_bottom,
          color: booking.status == 'confirmed'
              ? Colors.green
              : Colors.orange,
        ),
      ),
    );
  }
}
