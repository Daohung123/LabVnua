import 'package:aqedu/features/course_register/screens/view_courses_register.dart';
import 'package:aqedu/features/infor/screens/view_inforStudent.dart';
import 'package:aqedu/features/platform/services/local_analytics_service.dart';
import 'package:aqedu/features/prerequisite_subjects/screens/view_prequisite_subjects.dart';
import 'package:aqedu/features/program_training/screens/program_training_view.dart';
import 'package:aqedu/features/schedure/screens/study_view_day_month.dart';
import 'package:aqedu/features/score_data/screens/view_score_student.dart';
import 'package:aqedu/features/score_data/screens/view_study_analyst.dart';
import 'package:aqedu/features/task/screens/local_task_screen.dart';
import 'package:aqedu/features/tuition/screens/view_tuition.dart';
import 'package:flutter/material.dart';

class HocTapView extends StatefulWidget {
  const HocTapView({super.key, this.analyticsService});

  final LocalAnalyticsService? analyticsService;

  @override
  State<HocTapView> createState() => _HocTapViewState();
}

class _HocTapViewState extends State<HocTapView> {
  final _searchController = TextEditingController();
  late final LocalAnalyticsService _analyticsService;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _analyticsService = widget.analyticsService ?? LocalAnalyticsService();
    _analyticsService.recordEvent(
      eventName: 'open',
      featureName: 'learning_portal',
    );
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groups = _filteredGroups(context);
    final totalItems = kLearningPortalGroups.fold<int>(
      0,
      (sum, group) => sum + group.items.length,
    );
    final visibleItems = groups.fold<int>(
      0,
      (sum, group) => sum + group.items.length,
    );

    return Scaffold(
      backgroundColor: const Color(0xffF5F8FC),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: const Color(0xff0047A8),
        surfaceTintColor: const Color(0xff0047A8),
        foregroundColor: Colors.white,
        title: const Text(
          'Cổng học tập',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _LearningStats(
              totalItems: totalItems,
              visibleItems: visibleItems,
              groupCount: kLearningPortalGroups.length,
            ),
            const SizedBox(height: 14),
            TextField(
              key: const Key('learning-search-field'),
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Tìm chức năng học tập',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _analyticsService.recordEvent(
                eventName: 'search',
                featureName: 'learning_portal',
                metadata: const {'source': 'search_box'},
              ),
            ),
            const SizedBox(height: 18),
            if (groups.isEmpty)
              const _LearningEmptyState()
            else
              for (final group in groups) ...[
                _SectionHeader(title: group.title, subtitle: group.subtitle),
                _FeatureCard(
                  items: group.items,
                  onTap: (item) => _openItem(context, item),
                ),
                const SizedBox(height: 18),
              ],
          ],
        ),
      ),
    );
  }

  List<LearningPortalGroup> _filteredGroups(BuildContext context) {
    if (_query.isEmpty) return kLearningPortalGroups;
    return [
      for (final group in kLearningPortalGroups)
        LearningPortalGroup(
          title: group.title,
          subtitle: group.subtitle,
          items: group.items.where(_matchesQuery).toList(),
        ),
    ].where((group) => group.items.isNotEmpty).toList();
  }

  bool _matchesQuery(LearningPortalItem item) {
    final haystack = '${item.title} ${item.subtitle} ${item.key}'.toLowerCase();
    return haystack.contains(_query);
  }

  void _openItem(BuildContext context, LearningPortalItem item) {
    _analyticsService.recordEvent(
      eventName: 'open_item',
      featureName: 'learning_portal',
      metadata: {'item': item.key},
    );
    Navigator.push(context, MaterialPageRoute(builder: item.builder));
  }
}

class LearningPortalGroup {
  const LearningPortalGroup({
    required this.title,
    required this.subtitle,
    required this.items,
  });

  final String title;
  final String subtitle;
  final List<LearningPortalItem> items;
}

class LearningPortalItem {
  const LearningPortalItem({
    required this.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.builder,
  });

  final String key;
  final IconData icon;
  final String title;
  final String subtitle;
  final WidgetBuilder builder;
}

const kLearningPortalGroups = <LearningPortalGroup>[
  LearningPortalGroup(
    title: 'Học vụ',
    subtitle: 'Đào tạo, kết quả học tập và thông tin cá nhân',
    items: [
      LearningPortalItem(
        key: 'program',
        icon: Icons.school_outlined,
        title: 'CT đào tạo',
        subtitle: 'Xem chương trình đào tạo và lộ trình học',
        builder: _programTrainingBuilder,
      ),
      LearningPortalItem(
        key: 'prerequisites',
        icon: Icons.list_alt_outlined,
        title: 'Môn tiên quyết',
        subtitle: 'Kiểm tra các môn cần học trước',
        builder: _prerequisiteBuilder,
      ),
      LearningPortalItem(
        key: 'scores',
        icon: Icons.grade_outlined,
        title: 'Xem điểm',
        subtitle: 'Tra cứu điểm thành phần và điểm tổng kết',
        builder: _scoreBuilder,
      ),
      LearningPortalItem(
        key: 'profile',
        icon: Icons.account_box_outlined,
        title: 'Lý lịch',
        subtitle: 'Xem và cập nhật thông tin cá nhân',
        builder: _profileBuilder,
      ),
    ],
  ),
  LearningPortalGroup(
    title: 'Lịch học - thi cử',
    subtitle: 'Lịch học, lịch thi và đăng ký học phần',
    items: [
      LearningPortalItem(
        key: 'schedule',
        icon: Icons.today_outlined,
        title: 'TKB ngày',
        subtitle: 'Xem thời khóa biểu trong ngày',
        builder: _scheduleBuilder,
      ),
      LearningPortalItem(
        key: 'course_register',
        icon: Icons.edit_calendar_outlined,
        title: 'ĐK môn học',
        subtitle: 'Đăng ký hoặc điều chỉnh môn học',
        builder: _courseRegisterBuilder,
      ),
    ],
  ),
  LearningPortalGroup(
    title: 'Tiện ích',
    subtitle: 'Theo dõi tài chính, phân tích và todo offline',
    items: [
      LearningPortalItem(
        key: 'tuition',
        icon: Icons.monetization_on_outlined,
        title: 'Học phí',
        subtitle: 'Xem tình trạng và chi tiết học phí',
        builder: _tuitionBuilder,
      ),
      LearningPortalItem(
        key: 'analytics',
        icon: Icons.bar_chart_outlined,
        title: 'Phân tích học tập',
        subtitle: 'Xem thống kê và biểu đồ kết quả học tập',
        builder: _scoreAnalysisBuilder,
      ),
      LearningPortalItem(
        key: 'tasks',
        icon: Icons.task_alt_outlined,
        title: 'Todo offline',
        subtitle: 'Quản lý đầu việc local-first',
        builder: _taskBuilder,
      ),
    ],
  ),
];

Widget _programTrainingBuilder(BuildContext context) {
  return const ProgramTrainingView();
}

Widget _prerequisiteBuilder(BuildContext context) {
  return const PrerequisiteView();
}

Widget _scoreBuilder(BuildContext context) {
  return const ScoreStudentView();
}

Widget _profileBuilder(BuildContext context) {
  return const InforStudentView();
}

Widget _scheduleBuilder(BuildContext context) {
  return const ScheduleScreen();
}

Widget _courseRegisterBuilder(BuildContext context) {
  return const CourseRegisterView();
}

Widget _tuitionBuilder(BuildContext context) {
  return const HocPhiView();
}

Widget _scoreAnalysisBuilder(BuildContext context) {
  return const ScoreAnalysisView();
}

Widget _taskBuilder(BuildContext context) {
  return const LocalTaskScreen();
}

class _LearningStats extends StatelessWidget {
  const _LearningStats({
    required this.totalItems,
    required this.visibleItems,
    required this.groupCount,
  });

  final int totalItems;
  final int visibleItems;
  final int groupCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xff0047A8),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const Icon(Icons.school_rounded, color: Colors.white, size: 34),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cổng học tập',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$visibleItems/$totalItems chức năng · $groupCount nhóm',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.86),
                    fontSize: 13,
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff111827),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xff6B7280),
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.items, required this.onTap});

  final List<LearningPortalItem> items;
  final ValueChanged<LearningPortalItem> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xffE4EAF2)),
      ),
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            ListTile(
              key: Key('learning-item-${items[index].key}'),
              onTap: () => onTap(items[index]),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              leading: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xff0047A8).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(items[index].icon, color: const Color(0xff0047A8)),
              ),
              title: Text(
                items[index].title,
                style: const TextStyle(
                  color: Color(0xff111827),
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                ),
              ),
              subtitle: Text(
                items[index].subtitle,
                style: const TextStyle(
                  color: Color(0xff6B7280),
                  fontSize: 12.5,
                  height: 1.3,
                ),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
            if (index != items.length - 1)
              const Divider(height: 1, indent: 16, endIndent: 16),
          ],
        ],
      ),
    );
  }
}

class _LearningEmptyState extends StatelessWidget {
  const _LearningEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xffE4EAF2)),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off_outlined, size: 42, color: Color(0xff6B7280)),
          SizedBox(height: 12),
          Text(
            'Không tìm thấy chức năng',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 4),
          Text(
            'Thử từ khóa khác hoặc xóa nội dung tìm kiếm.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xff6B7280)),
          ),
        ],
      ),
    );
  }
}
