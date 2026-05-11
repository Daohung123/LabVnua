class CourseRegisterFilter {
  final int? giaTri;
  final String? mieuTa;
  final bool? isMacDinh;

  CourseRegisterFilter({
    this.giaTri,
    this.mieuTa,
    this.isMacDinh,
  });

  factory CourseRegisterFilter.fromJson(Map<String, dynamic> json) {
    return CourseRegisterFilter(
      giaTri: json['gia_tri'],
      mieuTa: json['mieu_ta'],
      isMacDinh: json['is_mac_dinh'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gia_tri': giaTri,
      'mieu_ta': mieuTa,
      'is_mac_dinh': isMacDinh,
    };
  }
}