import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/users/booking_service.dart';


class ViewBookingsScreen extends StatefulWidget {
  final String turfId; // Pass the turfId of the owner/admin

  const ViewBookingsScreen({super.key, required this.turfId});

  @override
  State<ViewBookingsScreen> createState() => _ViewBookingsScreenState();
}

class _ViewBookingsScreenState extends State<ViewBookingsScreen> {
  final BookingService _bookingService = BookingService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Bookings")),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _bookingService.getTurfBookings(widget.turfId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No bookings available"));
          }

          final bookings = snapshot.data!;
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: Text('${booking['userName']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Slot: ${booking['timeSlot']}'),
                      Text('Date: ${_formatTimestamp(booking['date'])}'),
                      Text('Paid: ₹${booking['price']}'),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(
                      booking['status'].toString().toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: _statusColor(booking['status']),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
