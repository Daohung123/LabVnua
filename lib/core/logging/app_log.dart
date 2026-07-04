import 'package:flutter/foundation.dart';

enum AppLogGroup {
  thaoTacNguoiDung('THAO TÁC NGƯỜI DÙNG'),
  vongDoiManHinh('VÒNG ĐỜI MÀN HÌNH'),
  ungDung('ỨNG DỤNG'),
  api('API'),
  coSoDuLieu('CƠ SỞ DỮ LIỆU'),
  dongBo('ĐỒNG BỘ'),
  thongBao('THÔNG BÁO'),
  chat('CHAT'),
  loi('LỖI');

  const AppLogGroup(this.title);

  final String title;
}

class AppLog {
  static const String _separator = '────────────────────────────────────────';
  static const String _redacted = '*** ĐÃ CHE ***';
  static const int _maxTextLength = 500;
  static const Set<String> _sensitiveKeys = {
    'password',
    'pass',
    'matkhau',
    'mật khẩu',
    'token',
    'cookie',
    'authorization',
    'secret',
    'apikey',
    'api_key',
    'api-key',
    'key',
  };

  const AppLog._();

  static void thaoTacNguoiDung(
    String suKien, {
    String? khuVuc,
    Object? duLieu,
    String? ketQua,
  }) {
    ghi(
      AppLogGroup.thaoTacNguoiDung,
      suKien: suKien,
      khuVuc: khuVuc,
      duLieu: duLieu,
      ketQua: ketQua,
    );
  }

  static void vongDoi(
    String suKien, {
    String? khuVuc,
    Object? duLieu,
    String? ketQua,
  }) {
    ghi(
      AppLogGroup.vongDoiManHinh,
      suKien: suKien,
      khuVuc: khuVuc,
      duLieu: duLieu,
      ketQua: ketQua,
    );
  }

  static void ungDung(
    String suKien, {
    String? khuVuc,
    Object? duLieu,
    String? ketQua,
  }) {
    ghi(
      AppLogGroup.ungDung,
      suKien: suKien,
      khuVuc: khuVuc,
      duLieu: duLieu,
      ketQua: ketQua,
    );
  }

  static void api(
    String suKien, {
    String? khuVuc,
    Object? duLieu,
    String? ketQua,
  }) {
    ghi(
      AppLogGroup.api,
      suKien: suKien,
      khuVuc: khuVuc,
      duLieu: duLieu,
      ketQua: ketQua,
    );
  }

  static void coSoDuLieu(
    String suKien, {
    String? khuVuc,
    Object? duLieu,
    String? ketQua,
  }) {
    ghi(
      AppLogGroup.coSoDuLieu,
      suKien: suKien,
      khuVuc: khuVuc,
      duLieu: duLieu,
      ketQua: ketQua,
    );
  }

  static void dongBo(
    String suKien, {
    String? khuVuc,
    Object? duLieu,
    String? ketQua,
  }) {
    ghi(
      AppLogGroup.dongBo,
      suKien: suKien,
      khuVuc: khuVuc,
      duLieu: duLieu,
      ketQua: ketQua,
    );
  }

  static void thongBao(
    String suKien, {
    String? khuVuc,
    Object? duLieu,
    String? ketQua,
  }) {
    ghi(
      AppLogGroup.thongBao,
      suKien: suKien,
      khuVuc: khuVuc,
      duLieu: duLieu,
      ketQua: ketQua,
    );
  }

  static void chat(
    String suKien, {
    String? khuVuc,
    Object? duLieu,
    String? ketQua,
  }) {
    ghi(
      AppLogGroup.chat,
      suKien: suKien,
      khuVuc: khuVuc,
      duLieu: duLieu,
      ketQua: ketQua,
    );
  }

  static void loi(
    String suKien, {
    String? khuVuc,
    Object? duLieu,
    Object? loi,
    StackTrace? stackTrace,
    String? ketQua,
  }) {
    ghi(
      AppLogGroup.loi,
      suKien: suKien,
      khuVuc: khuVuc,
      duLieu: {
        if (duLieu != null) 'du_lieu': duLieu,
        if (loi != null) 'nguyen_nhan': loi.toString(),
        if (stackTrace != null) 'stack_trace': _rutGonStackTrace(stackTrace),
      },
      ketQua: ketQua ?? 'Thao tác gặp lỗi, xem nguyên nhân ở dữ liệu log.',
    );
  }

  static void ghi(
    AppLogGroup nhom, {
    required String suKien,
    String? khuVuc,
    Object? duLieu,
    String? ketQua,
  }) {
    if (!kDebugMode) return;

    final lines = <String>[
      _separator,
      '[AQEDU] ${nhom.title}',
      'Thời gian : ${DateTime.now().toIso8601String()}',
      'Khu vực   : ${khuVuc ?? 'Không xác định'}',
      'Sự kiện   : $suKien',
      if (duLieu != null) 'Dữ liệu   : ${_formatValue(_redactValue(duLieu))}',
      if (ketQua != null) 'Kết quả   : $ketQua',
      _separator,
    ];

    // ignore: avoid_print
    print(lines.join('\n'));
  }

  @visibleForTesting
  static Object? redactForTest(Object? value) => _redactValue(value);

  @visibleForTesting
  static String formatForTest(Object? value) =>
      _formatValue(_redactValue(value));

  static Object? _redactValue(Object? value) {
    if (value == null) return null;

    if (value is Map) {
      return value.map((key, item) {
        final keyText = key.toString();
        if (_isSensitiveKey(keyText)) {
          return MapEntry(key, _redacted);
        }
        return MapEntry(key, _redactValue(item));
      });
    }

    if (value is Iterable && value is! String) {
      return value.map(_redactValue).toList();
    }

    final text = value.toString();
    return _truncate(text);
  }

  static bool _isSensitiveKey(String key) {
    final normalized = key.toLowerCase().replaceAll(RegExp(r'[\s_\-]'), '');
    return _sensitiveKeys.any((item) {
      final sensitive = item.toLowerCase().replaceAll(RegExp(r'[\s_\-]'), '');
      return normalized == sensitive || normalized.contains(sensitive);
    });
  }

  static String _formatValue(Object? value) {
    if (value == null) return 'null';
    if (value is Map) {
      final entries = value.entries
          .map((entry) {
            return '${entry.key}: ${_formatValue(entry.value)}';
          })
          .join(', ');
      return '{$entries}';
    }
    if (value is Iterable && value is! String) {
      return '[${value.map(_formatValue).join(', ')}]';
    }
    return value.toString();
  }

  static String _truncate(String text) {
    if (text.length <= _maxTextLength) return text;
    return '${text.substring(0, _maxTextLength)}... [đã rút gọn]';
  }

  static String _rutGonStackTrace(StackTrace stackTrace) {
    final lines = stackTrace.toString().split('\n');
    return lines.take(5).join(' | ');
  }
}
