import 'dart:convert';

import 'package:aqedu/config/config_DB.dart';
import 'package:aqedu/features/infor/models/models_inforStudent.dart';

import 'package:sqflite/sqflite.dart';

class ServiceSqlInformationStudentRoot {
  final DataBaseConfig _dbConfig = DataBaseConfig();

  static const String tableName = 'student_data';

  /// =====================================================
  /// INSERT OR REPLACE STUDENT
  /// =====================================================
  Future<int> insertStudent(StudentData student) async {
    final Database db = await _dbConfig.database;

    final data = student.toJson();

    // Convert List -> JSON String
    data['ds_menu_cam_xem'] =
        jsonEncode(student.dsMenuCamXem);

    // Convert bool -> int
    data['doi_mat_khau'] =
        student.doiMatKhau ? 1 : 0;

    data['is_master_pass'] =
        student.isMasterPass ? 1 : 0;

    data['is_cvht_dang_nhap'] =
        student.isCvhtDangNhap ? 1 : 0;

    data['is_phu_huynh_dang_nhap'] =
        student.isPhuHuynhDangNhap ? 1 : 0;

    data['is_nhap_dia_chi_moi'] =
        student.isNhapDiaChiMoi ? 1 : 0;

    data['is_xac_nhan_email'] =
        student.isXacNhanEmail ? 1 : 0;

    return await db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// =====================================================
  /// GET 1 STUDENT
  /// =====================================================
  Future<StudentData?> getStudent() async {
    final Database db = await _dbConfig.database;

    final result = await db.query(
      tableName,
      limit: 1,
    );

    if (result.isEmpty) return null;

    final map = Map<String, dynamic>.from(result.first);

    // Convert JSON String -> List
    map['ds_menu_cam_xem'] =
        jsonDecode(map['ds_menu_cam_xem'] ?? '[]');

    // Convert int -> bool
    map['doi_mat_khau'] =
        (map['doi_mat_khau'] ?? 0) == 1;

    map['is_master_pass'] =
        (map['is_master_pass'] ?? 0) == 1;

    map['is_cvht_dang_nhap'] =
        (map['is_cvht_dang_nhap'] ?? 0) == 1;

    map['is_phu_huynh_dang_nhap'] =
        (map['is_phu_huynh_dang_nhap'] ?? 0) == 1;

    map['is_nhap_dia_chi_moi'] =
        (map['is_nhap_dia_chi_moi'] ?? 0) == 1;

    map['is_xac_nhan_email'] =
        (map['is_xac_nhan_email'] ?? 0) == 1;

    return StudentData.fromJson(map);
  }

  /// =====================================================
  /// UPDATE STUDENT
  /// =====================================================
  Future<int> updateStudent(StudentData student) async {
    final Database db = await _dbConfig.database;

    final data = student.toJson();

    data['ds_menu_cam_xem'] =
        jsonEncode(student.dsMenuCamXem);

    data['doi_mat_khau'] =
        student.doiMatKhau ? 1 : 0;

    data['is_master_pass'] =
        student.isMasterPass ? 1 : 0;

    data['is_cvht_dang_nhap'] =
        student.isCvhtDangNhap ? 1 : 0;

    data['is_phu_huynh_dang_nhap'] =
        student.isPhuHuynhDangNhap ? 1 : 0;

    data['is_nhap_dia_chi_moi'] =
        student.isNhapDiaChiMoi ? 1 : 0;

    data['is_xac_nhan_email'] =
        student.isXacNhanEmail ? 1 : 0;

    return await db.update(
      tableName,
      data,
      where: 'ma_sv = ?',
      whereArgs: [student.maSv],
    );
  }

  /// =====================================================
  /// DELETE 1 STUDENT
  /// =====================================================
  Future<int> deleteStudent(String maSv) async {
    final Database db = await _dbConfig.database;

    return await db.delete(
      tableName,
      where: 'ma_sv = ?',
      whereArgs: [maSv],
    );
  }

  /// =====================================================
  /// DELETE ALL STUDENTS
  /// =====================================================
  Future<int> deleteAllStudents() async {
    final Database db = await _dbConfig.database;

    return await db.delete(tableName);
  }

  /// =====================================================
  /// CHECK STUDENT EXISTS
  /// =====================================================
  Future<bool> isStudentExists(String maSv) async {
    final Database db = await _dbConfig.database;

    final result = await db.query(
      tableName,
      where: 'ma_sv = ?',
      whereArgs: [maSv],
      limit: 1,
    );

    return result.isNotEmpty;
  }
}