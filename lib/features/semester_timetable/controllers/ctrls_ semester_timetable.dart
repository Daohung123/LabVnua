import 'package:flutter/material.dart';

import '../models/model_semester_timetable.dart';

class FakeSemesterTimetableController extends ChangeNotifier {
  List<SemesterTimetableItem> _list = [];

  List<SemesterTimetableItem> get list => _list;

  bool _loading = false;

  bool get loading => _loading;

  // fake load data
  Future<void> loadData() async {
    _loading = true;
    notifyListeners();

    // giả lập delay API
    await Future.delayed(const Duration(seconds: 2));

    _list = [
      SemesterTimetableItem(
        id: 1,
        idToHoc: "20252",
        maMon: "INT2204",
        tenMon: "Lập trình C++",
        nhomTo: "01",
        thu: 2,
        tietBatDau: 1,
        soTiet: 3,
        tuGio: "07:00",
        denGio: "09:30",
        phong: "A101",
        lop: "KTPM1",
        gv: "Nguyễn Văn A",
        tooltip: "Học lý thuyết",
      ),

      SemesterTimetableItem(
        id: 2,
        idToHoc: "20252",
        maMon: "INT2205",
        tenMon: "Flutter",
        nhomTo: "02",
        thu: 3,
        tietBatDau: 4,
        soTiet: 3,
        tuGio: "09:45",
        denGio: "12:15",
        phong: "B203",
        lop: "KTPM1",
        gv: "Trần Văn B",
        tooltip: "Thực hành",
      ),

      SemesterTimetableItem(
        id: 3,
        idToHoc: "20252",
        maMon: "INT2206",
        tenMon: "Cơ sở dữ liệu",
        nhomTo: "01",
        thu: 5,
        tietBatDau: 7,
        soTiet: 3,
        tuGio: "13:00",
        denGio: "15:30",
        phong: "C105",
        lop: "KTPM1",
        gv: "Lê Thị C",
        tooltip: "Lab",
      ),
    ];

    _loading = false;
    notifyListeners();
  }

  // lấy môn theo thứ
  List<SemesterTimetableItem> getByThu(int thu) {
    return _list.where((e) => e.thu == thu).toList();
  }

  // clear data
  void clear() {
    _list.clear();
    notifyListeners();
  }
}
