import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/features/chat/screens/chat_list_screen.dart';
import 'package:aqedu/features/course_register/screens/view_courses_register.dart';
import 'package:aqedu/features/home/home_view/components/home_models.dart';
import 'package:aqedu/features/notification/screens/view_noti_student.dart';
import 'package:aqedu/features/prerequisite_subjects/screens/view_prequisite_subjects.dart';
import 'package:aqedu/features/program_training/screens/program_training_view.dart';
import 'package:aqedu/features/qr_code/screens/view_qr_code.dart';
import 'package:aqedu/features/schedure/screens/study_view_day_month.dart';
import 'package:aqedu/features/score_data/screens/view_score_student.dart';
import 'package:aqedu/features/tuition/screens/view_tuition.dart';
import 'package:flutter/material.dart';

final List<HomeShortcutDefinition> kHomeShortcutCatalog = [
  HomeShortcutDefinition(
    key: 'schedule',
    label: 'TKB ngày',
    icon: Icons.today_outlined,
    color: AppColors.scheduleColor,
    builder: (_) => const ScheduleScreen(),
  ),
  HomeShortcutDefinition(
    key: 'scores',
    label: 'Xem điểm',
    icon: Icons.grade_outlined,
    color: AppColors.scoreColor,
    builder: (_) => const ScoreStudentView(),
  ),
  HomeShortcutDefinition(
    key: 'tuition',
    label: 'Học phí',
    icon: Icons.payments_outlined,
    color: AppColors.tuitionColor,
    builder: (_) => const HocPhiView(),
  ),
  HomeShortcutDefinition(
    key: 'chat',
    label: 'Chat',
    icon: Icons.forum_outlined,
    color: AppColors.materialsColor,
    builder: (_) => const ChatListScreen(),
  ),
  HomeShortcutDefinition(
    key: 'notifications',
    label: 'Thông báo',
    icon: Icons.notifications_active_outlined,
    color: AppColors.notificationColor,
    builder: (_) => const NotificationView(),
  ),
  HomeShortcutDefinition(
    key: 'course_register',
    label: 'Đăng ký học',
    icon: Icons.playlist_add_check_circle_outlined,
    color: AppColors.primaryLight,
    builder: (_) => const CourseRegisterView(),
  ),
  HomeShortcutDefinition(
    key: 'program',
    label: 'Chương trình',
    icon: Icons.account_tree_outlined,
    color: AppColors.info,
    builder: (_) => const ProgramTrainingView(),
  ),
  HomeShortcutDefinition(
    key: 'prerequisites',
    label: 'Tiên quyết',
    icon: Icons.schema_outlined,
    color: AppColors.warning,
    builder: (_) => const PrerequisiteView(),
  ),
  HomeShortcutDefinition(
    key: 'qr',
    label: 'Quét QR',
    icon: Icons.qr_code_scanner_outlined,
    color: AppColors.success,
    builder: (_) => const QRScannerView(),
  ),
];
