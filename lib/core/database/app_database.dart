import 'package:aqedu/config/config_db.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase({DataBaseConfig? config}) : _config = config ?? DataBaseConfig();

  final DataBaseConfig _config;

  Future<Database> get instance => _config.database;
}
