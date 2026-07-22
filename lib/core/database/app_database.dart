import 'package:aqedu/config/config_db.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class AppDatabase {
  AppDatabase({DataBaseConfig? config}) : _config = config ?? DataBaseConfig();

  final DataBaseConfig _config;

  Future<Database> get instance => _config.database;

  Future<String> get ownerHash => _config.ownerHash;
}
