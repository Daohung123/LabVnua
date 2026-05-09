/// Constants for schedule-related functionality
class ScheduleConstants {
  // Error and info messages
  static const String noScheduleTodayMessage = "Không có lịch học hôm nay";
  static const String noScheduleInWeekMessage = "Không có lịch trong tuần";
  static const String apiResponseNullMessage = "Phản hồi API trả về null";

  // Error log messages
  static const String errorGettingScheduleInDay = "Lỗi khi lấy lịch ngày: ";
  static const String errorGettingScheduleInWeek = "Lỗi khi lấy lịch tuần: ";
  static const String errorGettingScheduleToday = "Lỗi khi lấy lịch hôm nay: ";
  static const String errorParsingScheduleDate = "Lỗi parse ngày học: ";

  // Debug messages
  static const String foundCurrentWeekSchedule = "Tuần thứ: ";
  static const String foundTodaySchedule = "Đã tìm thấy lịch hôm nay: ";
}
