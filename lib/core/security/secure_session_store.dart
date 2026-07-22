import 'dart:convert';
import 'dart:math';

import 'package:aqedu/core/models/sqlite/session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureSessionStore {
  SecureSessionStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _userKey = 'aqedu.session.user';
  static const _passwordKey = 'aqedu.session.password';
  static const _cookieKey = 'aqedu.session.cookie';
  static const _tokenKey = 'aqedu.session.token';

  final FlutterSecureStorage _storage;

  Future<void> write(SessionModel session) async {
    await _storage.write(key: _userKey, value: session.user);
    await _storage.write(key: _passwordKey, value: session.pass);
    await _storage.write(key: _cookieKey, value: session.cookie);
    await _storage.write(key: _tokenKey, value: session.token);
  }

  Future<SessionModel?> read() async {
    final user = await _storage.read(key: _userKey);
    if (user == null || user.trim().isEmpty) return null;

    final password = await _storage.read(key: _passwordKey);
    final cookie = await _storage.read(key: _cookieKey);
    final token = await _storage.read(key: _tokenKey);
    if (password == null || cookie == null || token == null) return null;

    return SessionModel(
      user: user,
      pass: password,
      cookie: cookie,
      token: token,
    );
  }

  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _userKey),
      _storage.delete(key: _passwordKey),
      _storage.delete(key: _cookieKey),
      _storage.delete(key: _tokenKey),
    ]);
  }

  Future<String> readOrCreateDatabaseKey(String ownerHash) async {
    final key = 'aqedu.database.$ownerHash';
    final current = await _storage.read(key: key);
    if (current != null && current.isNotEmpty) return current;

    final random = Random.secure();
    final generated = base64UrlEncode(
      List<int>.generate(32, (_) => random.nextInt(256)),
    );
    await _storage.write(key: key, value: generated);
    return generated;
  }

  Future<void> deleteDatabaseKey(String ownerHash) {
    return _storage.delete(key: 'aqedu.database.$ownerHash');
  }
}
