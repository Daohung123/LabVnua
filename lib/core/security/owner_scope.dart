import 'dart:convert';

import 'package:crypto/crypto.dart';

class OwnerScope {
  const OwnerScope._();

  static String fromUser(String user) {
    final normalized = user.trim().toLowerCase();
    if (normalized.isEmpty) {
      throw ArgumentError.value(user, 'user', 'Mã người dùng không được trống.');
    }
    return sha256.convert(utf8.encode(normalized)).toString();
  }
}
