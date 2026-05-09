import 'package:intl/intl.dart';

/// Utility class for date/time parsing and comparison operations
class DateTimeHelper {
  static const String _dateFormat = 'dd/MM/yyyy';
  static final DateFormat _formatter = DateFormat(_dateFormat);

  /// Parse date string in "dd/MM/yyyy" format
  static DateTime? tryParseDate(String? dateString) {
    if (dateString == null || dateString.trim().isEmpty) {
      return null;
    }

    try {
      return _formatter.parse(dateString.trim());
    } catch (_) {
      return null;
    }
  }

  /// Parse ISO date string or "dd/MM/yyyy" format
  static DateTime? tryParseDateFlexible(String? dateString) {
    if (dateString == null || dateString.trim().isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(dateString.trim());
    } catch (_) {
      try {
        return _formatter.parse(dateString.trim());
      } catch (_) {
        return null;
      }
    }
  }

  /// Compare only date part (year, month, day)
  static bool isSameDay(DateTime dateA, DateTime dateB) {
    return dateA.year == dateB.year &&
        dateA.month == dateB.month &&
        dateA.day == dateB.day;
  }

  /// Get today's date at 00:00:00
  static DateTime getTodayAtMidnight() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Check if date is within range (inclusive)
  static bool isDateInRange(
    DateTime date,
    DateTime startDate,
    DateTime endDate,
  ) {
    return !date.isBefore(startDate) && !date.isAfter(endDate);
  }

  /// Normalize DateTime to 00:00:00
  static DateTime normalizeToMidnight(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}
