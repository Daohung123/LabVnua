import 'package:aqedu/features/teacher/models/teacher_api_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Teacher API models', () {
    test('parses teacher profile fields', () {
      final response = TeacherProfileResponse.fromJson({
        'data': {
          'id_giang_vien': 'gv-1',
          'ma_giang_vien': 'GV001',
          'ten_giang_vien': 'Nguyen Van A',
          'email_1': 'teacher@example.edu.vn',
          'khoa': 'Cong nghe thong tin',
          'bo_mon': 'He thong thong tin',
          'doi_mat_khau': true,
        },
        'result': true,
        'code': 200,
      });

      expect(response.result, isTrue);
      expect(response.code, 200);
      expect(response.data.idGiangVien, 'gv-1');
      expect(response.data.maGiangVien, 'GV001');
      expect(response.data.tenGiangVien, 'Nguyen Van A');
      expect(response.data.email1, 'teacher@example.edu.vn');
      expect(response.data.khoa, 'Cong nghe thong tin');
      expect(response.data.boMon, 'He thong thong tin');
      expect(response.data.doiMatKhau, isTrue);
    });

    test('parses teacher function list and mobile title', () {
      final response = TeacherFunctionResponse.fromJson({
        'data': {
          'total_items': 1,
          'total_pages': 1,
          'release_time': '2026-07-03',
          'is_phan_cap_chuc_nang_mobile': true,
          'ds_chuc_nang': [
            {
              'id': 'fn-1',
              'state': true,
              'ma_chuc_nang': 'TEACHER_HOME',
              'ma_menu': 'M01',
              'thu_tu': 2,
              'ten_hien_thi': 'Trang giang vien',
              'ten_mobile': {
                'nhom': 'Giang vien',
                'ten_viet': 'Lop hoc',
                'ten_eng': 'Classes',
                'ma_nhom_cha': 'ROOT',
              },
              'url': '/teacher/home',
              'ds_chi_tiet': [],
            },
          ],
          'ds_chuc_nang_htld': [],
        },
        'result': true,
        'code': 200,
      });

      expect(response.data.totalItems, 1);
      expect(response.data.isPhanCapChucNangMobile, isTrue);
      expect(response.data.dsChucNang, hasLength(1));

      final item = response.data.dsChucNang.first;
      expect(item.id, 'fn-1');
      expect(item.state, isTrue);
      expect(item.maChucNang, 'TEACHER_HOME');
      expect(item.thuTu, 2);
      expect(item.tenMobile.tenViet, 'Lop hoc');
      expect(item.tenMobile.tenEng, 'Classes');
    });

    test('parses teacher notifications with teacher permission field', () {
      final response = TeacherNotificationResponse.fromJson({
        'data': {
          'total_items': 1,
          'total_pages': 1,
          'notification': 1,
          'ds_thong_bao': [
            {
              'id': 'n-1',
              'doi_tuong_search': 'teacher',
              'doi_tuong': 2,
              'phan_cap_search': 'faculty',
              'phan_cap_giang_vien': 3,
              'tieu_de': 'Thong bao giang vien',
              'noi_dung': 'Noi dung',
              'is_phai_xem': false,
              'ngay_gui': '2026-07-03',
              'nguoi_gui': 'Phong dao tao',
              'is_da_doc': false,
              'ds_doi_tuong': [],
              'phan_hoi': '',
              'is_xem_phan_hoi': false,
              'ngay_xem': '',
            },
          ],
        },
        'result': true,
        'code': 200,
      });

      expect(response.data.notification, 1);
      expect(response.data.dsThongBao, hasLength(1));

      final item = response.data.dsThongBao.first;
      expect(item.phanCapGiangVien, 3);
      expect(item.tieuDe, 'Thong bao giang vien');
      expect(item.noiDung, 'Noi dung');
      expect(item.isDaDoc, isFalse);
    });

    test('uses safe defaults for missing or null optional fields', () {
      final profile = TeacherProfileResponse.fromJson({
        'data': {'id_giang_vien': null, 'doi_mat_khau': null},
      });
      final functions = TeacherFunctionResponse.fromJson({'data': {}});
      final notifications = TeacherNotificationResponse.fromJson({'data': {}});

      expect(profile.data.idGiangVien, '');
      expect(profile.data.doiMatKhau, isFalse);
      expect(functions.data.dsChucNang, isEmpty);
      expect(notifications.data.dsThongBao, isEmpty);
    });
  });
}
