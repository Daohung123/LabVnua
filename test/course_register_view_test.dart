import 'package:aqedu/features/course_register/controllers/ctrl_courses_register.dart';
import 'package:aqedu/features/course_register/models/model_course_register.dart';
import 'package:aqedu/features/course_register/models/model_course_register_fillter.dart';
import 'package:aqedu/features/course_register/screens/view_courses_register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Course registration filter safety', () {
    test('removes hidden and duplicate filter values', () {
      final visible = buildVisibleCourseRegisterFilters([
        CourseRegisterFilter(giaTri: 3, mieuTa: 'Ẩn', isMacDinh: true),
        CourseRegisterFilter(giaTri: 2, mieuTa: 'Theo CTĐT'),
        CourseRegisterFilter(giaTri: 2, mieuTa: 'Trùng'),
        CourseRegisterFilter(giaTri: 10, mieuTa: 'Ẩn 10'),
      ]);

      expect(visible.map((item) => item.giaTri), [2]);
      expect(
        resolveCourseRegisterFilterValue(
          filters: visible,
          currentValue: 3,
        ),
        2,
      );
    });

    test('returns null when no visible filter exists', () {
      expect(
        resolveCourseRegisterFilterValue(
          filters: [
            CourseRegisterFilter(giaTri: 3, isMacDinh: true),
            CourseRegisterFilter(giaTri: 10),
          ],
        ),
        isNull,
      );
    });
  });

  group('Course registration UI', () {
    testWidgets('renders when API default filter is hidden', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          home: CourseRegisterView(
            dataLoader: ({required bool forceRefresh}) async {
              return CourseRegisterScreenData(
                filters: [
                  CourseRegisterFilter(
                    giaTri: 3,
                    mieuTa: 'Bộ lọc ẩn',
                    isMacDinh: true,
                  ),
                  CourseRegisterFilter(
                    giaTri: 2,
                    mieuTa: 'Theo chương trình đào tạo',
                  ),
                ],
                catalog: CourseRegisterResponse(
                  idRs: 'register-session',
                  data: CourseRegisterData(
                    dsMonHoc: [
                      CourseRegisterSubject(
                        ma: 'TH01001',
                        ten: 'Cơ sở dữ liệu',
                      ),
                    ],
                    dsNhomTo: [
                      CourseRegisterClass(
                        idToHoc: 'class-1',
                        maMon: 'TH01001',
                        nhomTo: '01',
                        soTc: '3',
                        slCp: 40,
                        slCl: 10,
                        enable: true,
                        isDk: false,
                        isCtdt: true,
                      ),
                    ],
                  ),
                ),
                student: null,
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('course-register-content')), findsOneWidget);
      expect(find.text('Cơ sở dữ liệu - TH01001'), findsOneWidget);
      expect(find.text('Theo chương trình đào tạo'), findsOneWidget);
      expect(find.text('Bộ lọc ẩn'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows recoverable error state when loading fails', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CourseRegisterView(
            dataLoader: ({required bool forceRefresh}) async {
              throw StateError('offline');
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('course-register-error')), findsOneWidget);
      expect(find.byKey(const Key('course-register-retry')), findsOneWidget);
      expect(
        find.text('Chưa thể hiển thị đăng ký môn học'),
        findsOneWidget,
      );
    });
  });
}
