import 'package:aqedu/core/logging/app_log.dart';
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ghi log tiếng Việt theo dạng block dễ đọc', () {
    final outputs = <String>[];

    runZoned(
      () {
        AppLog.thaoTacNguoiDung(
          'Người dùng mở màn hình thông báo',
          khuVuc: 'Trang chủ',
          duLieu: {'so_luong_chua_doc': 3},
          ketQua: 'Đã điều hướng thành công',
        );
      },
      zoneSpecification: ZoneSpecification(
        print: (_, __, ___, line) => outputs.add(line),
      ),
    );

    expect(outputs, hasLength(1));
    expect(
      outputs.single,
      contains('────────────────────────────────────────'),
    );
    expect(outputs.single, contains('[AQEDU] THAO TÁC NGƯỜI DÙNG'));
    expect(outputs.single, contains('Thời gian :'));
    expect(outputs.single, contains('Khu vực   : Trang chủ'));
    expect(
      outputs.single,
      contains('Sự kiện   : Người dùng mở màn hình thông báo'),
    );
    expect(outputs.single, contains('Dữ liệu   : {so_luong_chua_doc: 3}'));
    expect(outputs.single, contains('Kết quả   : Đã điều hướng thành công'));
  });

  test('che dữ liệu nhạy cảm trong map lồng nhau', () {
    final redacted = AppLog.redactForTest({
      'username': 'sv001',
      'password': '123456',
      'headers': {'Authorization': 'Bearer secret', 'cookie': 'session=value'},
      'items': [
        {'apiKey': 'abc', 'name': 'safe'},
      ],
    });

    expect(redacted, {
      'username': 'sv001',
      'password': '*** ĐÃ CHE ***',
      'headers': {
        'Authorization': '*** ĐÃ CHE ***',
        'cookie': '*** ĐÃ CHE ***',
      },
      'items': [
        {'apiKey': '*** ĐÃ CHE ***', 'name': 'safe'},
      ],
    });
  });

  test('rút gọn dữ liệu quá dài', () {
    final formatted = AppLog.formatForTest({'noi_dung': 'a' * 700});

    expect(formatted, contains('[đã rút gọn]'));
    expect(formatted.length, lessThan(600));
  });
}
