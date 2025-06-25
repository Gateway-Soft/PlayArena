import 'package:flutter/material.dart';

class BookingTile extends StatelessWidget {
  final String turfName;
  final String location;
  final String bookingDate;
  final String timeSlot;
  final String status;
  final String imageUrl;

  const BookingTile({
    super.key,
    required this.turfName,
    required this.location,
    required this.bookingDate,
    required this.timeSlot,
    required this.status,
    required this.imageUrl,
  });

  Color getStatusColor() {
    switch (status.toLowerCase()) {
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

  IconData getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle;
      case 'pending':
        return Icons.timelapse;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image_not_supported, size: 60);
            },
          ),
        ),
        title: Text(turfName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location),
            Text("Date: $bookingDate"),
            Text("Time: $timeSlot"),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(getStatusIcon(), color: getStatusColor()),
            Text(status, style: TextStyle(color: getStatusColor(), fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
