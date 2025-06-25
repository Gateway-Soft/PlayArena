import 'package:intl/intl.dart';

class DateTimeHelper {
  /// 🔹 Format a DateTime to `dd-MM-yyyy`
  static String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  /// 🔹 Format a DateTime to `hh:mm a` (e.g., 07:45 PM)
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  /// 🔹 Format DateTime to `dd MMM yyyy - hh:mm a`
  static String formatFullDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy - hh:mm a').format(date);
  }

  /// 🔹 Format range like `10 Jun 2025 | 05:00 PM - 06:00 PM`
  static String formatDateTimeRange(DateTime start, DateTime end) {
    final dateStr = DateFormat('dd MMM yyyy').format(start);
    final startStr = DateFormat('hh:mm a').format(start);
    final endStr = DateFormat('hh:mm a').format(end);
    return '$dateStr | $startStr - $endStr';
  }

  /// 🔹 Convert Firestore Timestamp to formatted full date-time
  static String formatFromTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    final date = timestamp.toDate();
    return formatFullDateTime(date);
  }

  /// 🔹 Returns relative time like "2 days ago", "3 hours ago"
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays >= 1) {
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
