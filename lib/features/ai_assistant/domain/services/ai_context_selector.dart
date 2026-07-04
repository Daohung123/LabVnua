class AiContextSelector {
  static const notificationKeywords = [
    'thông báo',
    'tin nhắn',
    'notice',
    'notification',
    'công văn',
    'học vụ',
  ];

  static const scheduleKeywords = [
    'lịch',
    'thời khóa biểu',
    'tkb',
    'phòng',
    'giảng viên',
    'môn học',
  ];

  bool shouldLoadNotifications(String prompt) {
    final lower = prompt.toLowerCase();
    return notificationKeywords.any(lower.contains);
  }

  bool shouldLoadSchedule(String prompt) {
    final lower = prompt.toLowerCase();
    return scheduleKeywords.any(lower.contains);
  }
}
