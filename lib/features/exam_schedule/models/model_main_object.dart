import 'package:aqedu/features/exam_schedule/models/model_data_scores.dart';

class LichThi {
  final String idNhomThi;
  final String idMonHoc;
  final String idKqdk;

  final int soThuTu;
  final String kyThi;
  final String dotThi;

  final String maMon;
  final String tenMon;
  final String tenMonEg;

  final String maPhong;
  final String maCoSo;

  final String ngayThi;
  final String tietBatDau;
  final String soTiet;
  final String gioBatDau;
  final String soPhut;

  final String hinhThucThi;

  final String diaDiemThi;

  final int siSo;

  final List<DiemMonHoc> dsDiemMonHoc;

  LichThi({
    required this.idNhomThi,
    required this.idMonHoc,
    required this.idKqdk,
    required this.soThuTu,
    required this.kyThi,
    required this.dotThi,
    required this.maMon,
    required this.tenMon,
    required this.tenMonEg,
    required this.maPhong,
    required this.maCoSo,
    required this.ngayThi,
    required this.tietBatDau,
    required this.soTiet,
    required this.gioBatDau,
    required this.soPhut,
    required this.hinhThucThi,
    required this.diaDiemThi,
    required this.siSo,
    required this.dsDiemMonHoc,
  });

  factory LichThi.fromJson(Map<String, dynamic> json) {
    return LichThi(
      idNhomThi: json['id_nhom_thi'],
      idMonHoc: json['id_mon_hoc'],
      idKqdk: json['id_kqdk'],
      soThuTu: json['so_thu_tu'],
      kyThi: json['ky_thi'] ?? '',
      dotThi: json['dot_thi'] ?? '',
      maMon: json['ma_mon'] ?? '',
      tenMon: json['ten_mon'] ?? '',
      tenMonEg: json['ten_mon_eg'] ?? '',
      maPhong: json['ma_phong'] ?? '',
      maCoSo: json['ma_co_so'] ?? '',
      ngayThi: json['ngay_thi'] ?? '',
      tietBatDau: json['tiet_bat_dau'] ?? '',
      soTiet: json['so_tiet'] ?? '',
      gioBatDau: json['gio_bat_dau'] ?? '',
      soPhut: json['so_phut'] ?? '',
      hinhThucThi: json['hinh_thuc_thi'] ?? '',
      diaDiemThi: (json['dia_diem_thi'] ?? '').trim(),
      siSo: json['si_so'] ?? 0,
      dsDiemMonHoc: (json['ds_diem_mon_hoc'] as List)
          .map((e) => DiemMonHoc.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id_nhom_thi': idNhomThi,
        'id_mon_hoc': idMonHoc,
        'id_kqdk': idKqdk,
        'so_thu_tu': soThuTu,
        'ky_thi': kyThi,
        'dot_thi': dotThi,
        'ma_mon': maMon,
        'ten_mon': tenMon,
        'ten_mon_eg': tenMonEg,
        'ma_phong': maPhong,
        'ma_co_so': maCoSo,
        'ngay_thi': ngayThi,
        'tiet_bat_dau': tietBatDau,
        'so_tiet': soTiet,
        'gio_bat_dau': gioBatDau,
        'so_phut': soPhut,
        'hinh_thuc_thi': hinhThucThi,
        'dia_diem_thi': diaDiemThi,
        'si_so': siSo,
        'ds_diem_mon_hoc':
            dsDiemMonHoc.map((e) => e.toJson()).toList(),
      };
}