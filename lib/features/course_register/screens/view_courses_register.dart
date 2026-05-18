import 'package:flutter/material.dart';

import '../controlers/ctrl_courses_register.dart';
import '../models/model_course_register.dart';
import '../models/model_course_register_fillter.dart';
import '../models/model_course_register_results.dart';

class CourseRegisterView extends StatefulWidget {
  const CourseRegisterView({super.key});

  @override
  State<CourseRegisterView> createState() =>
      _CourseRegisterViewState();
}

class _CourseRegisterViewState
    extends State<CourseRegisterView> {
  List<CourseRegisterFilter> filters = [];

  List<CourseRegisterClass> classes = [];

  CourseRegisterResultResponse? registerResult;

  CourseRegisterFilter? selectedFilter;

  bool isLoading = true;
  bool isActionLoading = false;

  String? errorMessage;
  String? message;

  final int svNganh = 1;

  String currentIdRs = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final controller =
          await CtrlCourseRegister.create();

      final filterResult =
          await controller.getFilters();

      final classResult =
          await controller.getClasses();

      if (classResult.isNotEmpty) {
        currentIdRs =
            classResult.first.idRs ??
                currentIdRs;
      }

      final resultData =
          await controller
              .getCourseRegisterResult();

      setState(() {
        filters = filterResult;

        classes = classResult;

        registerResult = resultData;

        selectedFilter = filters
            .where(
              (e) => e.isMacDinh == true,
            )
            .cast<CourseRegisterFilter?>()
            .firstOrNull;

        selectedFilter ??=
            filters.isNotEmpty
                ? filters.first
                : null;

        isLoading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        errorMessage =
            "Không thể tải dữ liệu";
        isLoading = false;
      });
    }
  }

  Future<void> actionCourse({
    required CourseRegisterClass item,
    required bool isChecked,
  }) async {
    try {
      setState(() {
        isActionLoading = true;
        message = null;
      });

      final controller =
          await CtrlCourseRegister.create();

      print(
        "CURRENT ID_RS: $currentIdRs",
      );

      print(
        "ID_TO_HOC: ${item.idToHoc}",
      );

      final response =
          await controller
              .actionCourseRegister(
        idToHoc: item.idToHoc ?? "",
        isChecked: isChecked,
        svNganh: svNganh,
        idRs: currentIdRs,
      );

      if (response?.data?.idRs != null) {
        currentIdRs =
            response!.data!.idRs!;
      }

      print(
        "NEW ID_RS: $currentIdRs",
      );

      if (response?.data?.isThanhCong ==
          true) {
        setState(() {
          message = isChecked
              ? "Đăng ký thành công"
              : "Huỷ thành công";
        });

        await loadData();
      } else {
        setState(() {
          message =
              response
                  ?.data?.thongBaoLoi ??
              "Thao tác thất bại";
        });
      }
    } catch (e) {
      print(e);

      setState(() {
        message =
            "Có lỗi xảy ra: $e";
      });
    } finally {
      setState(() {
        isActionLoading = false;
      });
    }
  }

  List<CourseRegisterClass>
      get filteredClasses {
    if (selectedFilter == null) {
      return classes;
    }

    return classes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xffF6F7FB),

      appBar: AppBar(
        title: const Text(
          "Đăng ký tín chỉ",
        ),
        centerTitle: true,
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : errorMessage != null
              ? Center(
                  child:
                      Text(errorMessage!),
                )
              : RefreshIndicator(
                  onRefresh: loadData,

                  child: ListView(
                    padding:
                        const EdgeInsets.all(
                      12,
                    ),

                    children: [
                      _buildFilter(),

                      const SizedBox(
                        height: 12,
                      ),

                      if (message != null)
                        _buildMessage(),

                      const SizedBox(
                        height: 12,
                      ),

                      _buildResultBox(),

                      const SizedBox(
                        height: 12,
                      ),

                      const Text(
                        "Danh sách lớp học phần",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      ...filteredClasses.map(
                        _buildClassItem,
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildFilter() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(14),
      ),

      child:
          DropdownButtonHideUnderline(
        child:
            DropdownButton<
              CourseRegisterFilter
            >(
          value: selectedFilter,

          isExpanded: true,

          items:
              filters.map((item) {
            return DropdownMenuItem(
              value: item,

              child: Text(
                item.mieuTa ?? "",
              ),
            );
          }).toList(),

          onChanged: (value) {
            setState(() {
              selectedFilter = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildMessage() {
    return Container(
      padding: const EdgeInsets.all(
        12,
      ),

      decoration: BoxDecoration(
        color: Colors.blue.shade50,

        borderRadius:
            BorderRadius.circular(12),
      ),

      child: Text(
        message ?? "",
      ),
    );
  }

  Widget _buildResultBox() {
    final items =
        registerResult
            ?.data
            ?.dsKqdkmh ??
        [];

    return Container(
      padding: const EdgeInsets.all(
        14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            "Kết quả đăng ký",

            style: TextStyle(
              fontSize: 17,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Tổng môn: ${items.length}",
          ),

          Text(
            "Ngày in: ${registerResult?.data?.ngayIn ?? "-"}",
          ),

          const SizedBox(height: 8),

          if (items.isEmpty)
            const Text(
              "Chưa có môn đăng ký",
            ),
        ],
      ),
    );
  }

  Widget _buildClassItem(
    CourseRegisterClass item,
  ) {
    final canRegister =
        item.enable == true;

    final isRegistered =
        item.isDk == true;

    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      padding: const EdgeInsets.all(
        14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            item.maMon ?? "",

            style: const TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            item.tenMon ??
                item.tenMonEg ??
                "",
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,

            children: [
              _chip(
                "Nhóm ${item.nhomTo ?? "-"}",
              ),

              _chip(
                "${item.soTc ?? "0"} tín chỉ",
              ),

              _chip(
                "Còn ${item.slCl ?? 0}/${item.slCp ?? 0}",
              ),

              if (isRegistered)
                _chip("Đã đăng ký"),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            _formatTkb(item.tkb),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Text(
                  isRegistered
                      ? "Đã đăng ký"
                      : canRegister
                          ? "Có thể đăng ký"
                          : item.gcEnable ??
                              "Không thể đăng ký",

                  style: TextStyle(
                    color: isRegistered
                        ? Colors.blue
                        : canRegister
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
              ),

              if (isRegistered)
                ElevatedButton(
                  onPressed:
                      isActionLoading
                          ? null
                          : () {
                              actionCourse(
                                item: item,
                                isChecked:
                                    false,
                              );
                            },

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red,
                  ),

                  child: const Text(
                    "Huỷ",
                  ),
                )
              else
                ElevatedButton(
                  onPressed:
                      canRegister &&
                              !isActionLoading
                          ? () {
                              actionCourse(
                                item: item,
                                isChecked:
                                    true,
                              );
                            }
                          : null,

                  child: const Text(
                    "Đăng ký",
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: const Color(
          0xffF1F3F6,
        ),

        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child: Text(
        text,

        style: const TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }

  String _formatTkb(String? tkb) {
    if (tkb == null || tkb.isEmpty) {
      return "Chưa có thời khóa biểu";
    }

    return tkb.replaceAll(
      "<hr>",
      "\n",
    );
  }
}